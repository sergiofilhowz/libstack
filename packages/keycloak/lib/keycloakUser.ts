import { AxiosInstance } from 'axios';
import { ActionsEmail, CredentialsRepresentation, RoleRepresentation, UserRepresentation } from './models';
import { keycloakClient, KeycloakClient } from './keycloak';
import { UserCreationError } from './errors';

export class KeycloakUserService {
  private readonly server: AxiosInstance;
  private readonly realm: string;

  constructor(keycloakClient: KeycloakClient) {
    this.server = keycloakClient.server;
    this.realm = keycloakClient.realm;
  }

  /**
   * Creates a new user and returns its generated ID
   * @param user
   * @throws UserCreationError when Keycloak returns code 409
   */
  async createUser(user: UserRepresentation): Promise<string> {
    try {
      const { headers } = await this.server.post(`/admin/realms/${this.realm}/users`, user);
      return headers.location.replace(/^.*\/([^/]+)$/, '$1');
    } catch (err) {
      if (err.response?.status === 409) {
        throw new UserCreationError(err.response?.data?.errorMessage);
      }
      throw err;
    }
  }

  /**
   * Deletes the user based on the given ID
   * @param userId
   */
  async deleteUser(userId: string): Promise<void> {
    await this.server.delete(`/admin/realms/${this.realm}/users/${userId}`);
  }

  /**
   * Returns the user based on the given ID
   * @param userId
   */
  async getUser(userId: string): Promise<UserRepresentation> {
    const { data } = await this.server.get(`/admin/realms/${this.realm}/users/${userId}`);
    return data;
  }

  /**
   * Update an user based on the given ID
   * @param userId
   * @param user
   * @throws UserCreationError when Keycloak returns code 409
   */
  async updateUser(userId: string, user: UserRepresentation): Promise<void> {
    try {
      await this.server.put(`/admin/realms/${this.realm}/users/${userId}`, user);
    } catch (err) {
      if (err.response?.status === 409) {
        throw new UserCreationError(err.response?.data?.errorMessage);
      }
      throw err;
    }
  }

  /**
   * Will assign a realm role to the user with the given ID
   * @param userId
   * @param role
   */
  async addRealmRole(userId: string, role: RoleRepresentation|RoleRepresentation []): Promise<void> {
    const roles: RoleRepresentation [] = Array.isArray(role) ? role : [role];
    await this.server.post(`/admin/realms/${this.realm}/users/${userId}/role-mappings/realm`, roles);
  }

  /**
   * Will return all assigned realm roles to the user
   * @param userId
   */
  async getRealmRoles(userId: string): Promise<RoleRepresentation []> {
    const { data } = await this.server.get(`/admin/realms/${this.realm}/users/${userId}/role-mappings/realm`);
    return data;
  }

  /**
   * Will remove a realm role from the user with the given ID
   * @param userId
   * @param role
   */
  async removeRealmRole(userId: string, role: RoleRepresentation|RoleRepresentation []): Promise<void> {
    const roles: RoleRepresentation [] = Array.isArray(role) ? role : [role];
    await this.server.delete(`/admin/realms/${this.realm}/users/${userId}/role-mappings/realm`, {
      data: roles
    });
  }

  /**
   * Resets the user's password
   * @param userId      The user ID to reset the password
   * @param password    The new password
   * @param temporary   Wether this password is temporary or not. Defaults to false
   */
  async resetUserPassword(userId: string, password: string, temporary: boolean = false) {
    const credentials: CredentialsRepresentation = {
      temporary,
      type: 'password',
      value: password
    };
    await this.server.put(`/admin/realms/${this.realm}/users/${userId}/reset-password`, credentials);
  }

  /**
   * Sends an email to the user's email to perform all required actions
   * @param userId
   * @param payload Options to send the actions email
   */
  async executeActionsEmail(userId: string, payload: ActionsEmail): Promise<void> {
    const url: string = `/admin/realms/${this.realm}/users/${userId}/execute-actions-email`;
    await this.server.put(url, payload.actions, {
      params: {
        lifespan: payload.lifespan,
        redirect_uri: payload.redirectUri,
        client_id: payload.clientId,
      }
    });
  }
}

export const keycloakUserService = new KeycloakUserService(keycloakClient);