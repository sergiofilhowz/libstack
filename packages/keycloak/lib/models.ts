import _ from 'lodash';

export declare type RequiredAction = 'CONFIGURE_TOTP' | 'VERIFY_EMAIL' | 'UPDATE_PASSWORD' | 'UPDATE_PROFILE';

export interface UserRepresentation {
  id?: string;
  attributes?: { [key:string]: string [] };
  email?: string;
  emailVerified?: boolean;
  enabled?: boolean;
  firstName?: string;
  lastName?: string;

  requiredActions?: RequiredAction [];
  username?: string;
}

export interface GroupRepresentation {
  name: string;
  attributes?: { [key:string]: string [] };
}

export interface CredentialsRepresentation {
  type?: string;
  value: string;
  temporary: boolean;
}

export interface RoleRepresentation {
  id: string;
  name: string;
  description: string;
  composite: boolean;
  clientRole: boolean;
}

export interface ResourceAccess {
  roles: string [];
}

export interface KeycloakTokenInfo {
  sub: string;
  name: string;
  given_name: string;
  family_name: string;

  realm_access: ResourceAccess;

  resource_access: { [client:string]: ResourceAccess };

  scope: string;
  client_id: string;

  username: string;
  preferred_username: string;

  active: boolean;
}

/**
 * Options to send the actions email
 */
export interface ActionsEmail {
  /**
   * This uri will be present on the email, when the user
   * finally finishes the required actions, he or she will
   * be redirected to the uri provided here
   */
  redirectUri?: string;

  /**
   * When Redirect URI is present, you will need to provide the clientId
   */
  clientId?: string;

  /**
   * Number of seconds after which the generated token expires
   */
  lifespan?: number;

  /**
   * Required actions the user needs to complete
   */
  actions: RequiredAction [];
}

/**
 * This is the session representation from Keycloak.
 * If you need further details for the user, it's better to
 * call the KeycloakUserService to get the user informations,
 * for example, the attributes, etc.
 */
export class TokenInfo {
  /**
   * The ID of the user performing the request
   */
  readonly userId: string;

  /**
   * The name of the user performing the request
   */
  readonly name: string;

  /**
   * The first name of the user performing the request
   */
  readonly firstName: string;

  /**
   * The last name of the user performing the request
   */
  readonly lastName: string;

  /**
   * Contains the realm roles assigned to this user
   */
  readonly realmAccess: ResourceAccess;

  /**
   * Contains the clients roles assigned to this user
   */
  readonly clientAccess: { [client:string]: ResourceAccess };

  /**
   * The scope provided by the user on the token
   */
  readonly scope: string;

  /**
   * The client id used to issue the token
   */
  readonly clientId: string;

  /**
   * The user name of the user performing the request
   */
  readonly username: string;

  /**
   * Wether this user is active or not (Used internally)
   */
  readonly active: boolean;

  constructor(tokenInfo: KeycloakTokenInfo) {
    this.userId = tokenInfo.sub;
    this.name = tokenInfo.name;
    this.firstName = tokenInfo.given_name;
    this.lastName = tokenInfo.family_name;
    this.realmAccess = tokenInfo.realm_access;
    this.clientAccess = tokenInfo.resource_access;
    this.scope = tokenInfo.scope;
    this.username = tokenInfo.username;
    this.active = tokenInfo.active;
  }

  /**
   * Check if the user the a client role
   * @param clientId  The client for your application
   * @param roles     The role or roles to check. If it's an array, only one role must be present in order to be true.
   */
  hasClientRole(clientId: string, roles: string|string[]): boolean {
    const rolesToCheck: string [] = typeof roles === 'string' ? [roles] : roles;
    const tokenRoles: string [] = this.clientAccess?.[clientId]?.roles;
    return tokenRoles && _.intersection(tokenRoles, rolesToCheck).length > 0;
  }
}

export interface AuthenticatedUser {
  token: TokenInfo;
  userId: string;
}