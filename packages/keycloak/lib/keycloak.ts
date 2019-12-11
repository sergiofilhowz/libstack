import axios, { AxiosInstance } from 'axios';
import querystring from 'query-string';
import {
  CallableStack,
  config,
  Config,
  ForbiddenError,
  Interceptor,
  RestInterceptor,
  UnauthorizedError
} from '@libstack/server';
import { RoleRepresentation, TokenInfo } from './models';
import { Request, Response } from 'express';
import { KeycloakError } from './errors';

const enabled: boolean = config.getBoolean('KEYCLOAK_ENABLED');
const validateTokenConfig = {
  headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
};

/**
 * This interface contains the keycloak session in addition
 * to the Express Request
 */
export interface KeycloakRequest extends Request {
  /**
   * The session attached to the request if the request is
   * fully authenticated with the JWT keycloak token
   */
  session?: TokenInfo;
}

export class KeycloakClient {
  private readonly keycloakAuthUrl: string;
  private readonly clientId: string;
  private readonly clientSecret: string;
  private readonly basicAuth: string;
  private readonly validateUrl: string;
  private readonly tokenUrl: string;

  readonly realm: string;
  readonly server: AxiosInstance;

  private accessToken: string;

  constructor(config: Config) {
    this.keycloakAuthUrl = config.get('KEYCLOAK_AUTH_URL');
    this.clientId = config.get('KEYCLOAK_CLIENT_ID');
    this.clientSecret = config.get('KEYCLOAK_CLIENT_SECRET');
    this.realm = config.get('KEYCLOAK_REALM');

    this.basicAuth = Buffer.from(`${this.clientId}:${this.clientSecret}`).toString('base64');
    this.validateUrl = `/realms/${this.realm}/protocol/openid-connect/token/introspect`;
    this.tokenUrl = `/realms/${this.realm}/protocol/openid-connect/token`;
    this.server = axios.create({ baseURL: this.keycloakAuthUrl });
    this.server.interceptors.response.use(null, err => this.interceptAxiosError(err));
  }

  /**
   * Returns the realm role based on the role name
   * @param roleName the role actual name
   */
  async getRealmRole(roleName: string): Promise<RoleRepresentation> {
    try {
      const { data } = await this.server.get(`/admin/realms/${this.realm}/roles/${roleName}`);
      return data;
    } catch (err) {
      if (err?.status === 404) {
        throw new KeycloakError(`Role ${roleName} not found`);
      }
      throw err;
    }
  }

  async validateAccessToken(token: string): Promise<TokenInfo> {
    const body: string = querystring.stringify({
      token,
      client_id: this.clientId,
      client_secret: this.clientSecret
    });
    const { data } = await this.server.post(this.validateUrl, body, validateTokenConfig);
    return new TokenInfo(data);
  }

  async interceptExpressRequest(request: KeycloakRequest, role: string) {
    const bearer = request.headers.authorization;
    if (!bearer) {
      throw new UnauthorizedError('Not Authorized');
    }

    const tokenInfo: TokenInfo = await this.validateAccessToken(bearer.substr('bearer '.length));
    if (!tokenInfo.active) {
      throw new UnauthorizedError('Not Authorized');
    }
    if (!tokenInfo.hasClientRole(this.clientId, role)) {
      throw new ForbiddenError('Not Authorized');
    }
    request.session = tokenInfo;
  };

  async interceptAxiosError(error: any): Promise<any> {
    if (error?.response?.status === 401) {
      await this.interceptAxiosRequest(error.config, true);
      return axios.request(error.config);
    }
    throw error;
  };

  async interceptAxiosRequest(request: any, renew: boolean) {
    if (!this.accessToken || renew) {
      const body = querystring.stringify({ grant_type: 'client_credentials' });
      const { data } = await this.server.post(this.tokenUrl, body, {
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': `Basic ${this.basicAuth}`
        }
      });

      this.accessToken = data['access_token'];
    }

    request.headers.Authorization = `Bearer ${this.accessToken}`;
    return request;
  }
}

export const keycloakClient = new KeycloakClient(config);

@RestInterceptor({ disabled: !enabled })
export class KeycloakInterceptor implements Interceptor {
  intercepts(parameters: any, request: Request): boolean {
    return parameters && parameters.roles;
  }

  async execute(parameters: any, req: KeycloakRequest, res: Response, stack: CallableStack): Promise<any> {
    await keycloakClient.interceptExpressRequest(req, parameters.roles);
    return stack.next();
  }
}