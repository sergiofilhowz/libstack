import axios from 'axios';
import querystring from 'query-string';
import _ from 'lodash';
import { Request, Response } from 'express';
import { CallableStack, ForbiddenError, Interceptor, RestInterceptor, UnauthorizedError } from '@libstack/router';
import { config, Config } from '@libstack/server';

const validateTokenConfig = {
  headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
};

class KeycloakClient {
  keycloakAuthUrl: string;
  clientId: string;
  clientSecret: string;
  realm: string;
  basicAuth: string;
  validateUrl: string;
  tokenUrl: string;
  server: any;

  accessToken: string;

  constructor(config: Config) {
    this.keycloakAuthUrl = config.get('KEYCLOAK_AUTH_URL');
    this.clientId = config.get('KEYCLOAK_CLIENT_ID');
    this.clientSecret = config.get('KEYCLOAK_CLIENT_SECRET');
    this.realm = config.get('KEYCLOAK_REALM');

    this.basicAuth = Buffer.from(`${this.clientId}:${this.clientSecret}`).toString('base64');
    this.validateUrl = `/realms/${this.realm}/protocol/openid-connect/token/introspect`;
    this.tokenUrl = `/realms/${this.realm}/protocol/openid-connect/token`;
    this.server = axios.create({ baseURL: this.keycloakAuthUrl });
  }

  async validateAccessToken(token: string) {
    const body: string = querystring.stringify({
      token,
      client_id: this.clientId,
      client_secret: this.clientSecret
    });
    const { data } = await this.server.post(this.validateUrl, body, validateTokenConfig);
    data.hasRole = (roles: Array<string> | string): boolean => {
      const rolesToCheck: string [] = typeof roles === 'string' ? [roles] : roles;
      const tokenRoles = _.get(data, `resource_access.${this.clientId}.roles`);
      return tokenRoles && _.intersection(tokenRoles, rolesToCheck).length > 0;
    };
    return data;
  }

  async interceptExpressRequest(request: any, role: string) {
    const bearer = request.headers['authorization'];
    if (!bearer) {
      throw new UnauthorizedError('Not Authorized');
    }

    const tokenData = await this.validateAccessToken(bearer.substr('bearer '.length));
    if (!tokenData.active) {
      throw new UnauthorizedError('Not Authorized');
    }
    if (!tokenData.hasRole(role)) {
      throw new ForbiddenError('Not Authorized');
    }
    request.tokenData = tokenData;
  };

  async interceptAxiosError(error: any) {
    if (error.response.status === 401) {
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

const keycloakClient = new KeycloakClient(config);
const enabled: boolean = config.getBoolean('KEYCLOAK_ENABLED');

@RestInterceptor({ disabled: !enabled })
class KeycloakInterceptor implements Interceptor {
  intercepts(parameters: any, request: Request): boolean {
    return parameters && parameters.roles;
  }

  async execute(parameters: any, req: Request, res: Response, stack: CallableStack): Promise<any> {
    await keycloakClient.interceptExpressRequest(req, parameters.roles);
    return stack.next();
  }
}

export default keycloakClient;