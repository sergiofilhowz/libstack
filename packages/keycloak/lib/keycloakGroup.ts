import { AxiosInstance } from 'axios';
import { GroupRepresentation, RoleRepresentation, UserRepresentation } from './models';
import { keycloakClient, KeycloakClient } from './keycloak';
import { GroupCreationError } from './errors';

export class KeycloakGroupService {

  private readonly server: AxiosInstance;
  private readonly realm: string;

  constructor(keycloakClient: KeycloakClient) {
    this.server = keycloakClient.server;
    this.realm = keycloakClient.realm;
  }

  /**
   * Creates a new group and returns its generated ID
   * @param group
   * @throws GroupCreationError when Keycloak returns code 409
   */
  async createGroup(group: GroupRepresentation): Promise<string> {
    try {
      const { headers } = await this.server.post(`/admin/realms/${this.realm}/groups`, group);
      return headers.location.replace(/^.*\/([^/]+)$/, '$1');
    } catch (err) {
      if (err.response?.status === 409) {
        throw new GroupCreationError(err.response?.data?.errorMessage);
      }
      throw err;
    }
  }

  /**
   * Returns the group based on the given ID
   * @param groupId
   */
  async getGroup(groupId: string): Promise<GroupRepresentation> {
    const { data } = await this.server.get(`/admin/realms/${this.realm}/groups/${groupId}`);
    return data;
  }

  /**
   * Deletes the group based on the given ID
   * @param groupId
   */
  async deleteGroup(groupId: string): Promise<void> {
    await this.server.delete(`/admin/realms/${this.realm}/groups/${groupId}`);
  }

  /**
   * Update a group based on the given ID
   * @param groupId
   * @param group
   * @throws GroupCreationError when Keycloak returns code 409
   */
  async updateGroup(groupId: string, group: GroupRepresentation): Promise<void> {
    try {
      await this.server.put(`/admin/realms/${this.realm}/groups/${groupId}`, group);
    } catch (err) {
      if (err.response?.status === 409) {
        throw new GroupCreationError(err.response?.data?.errorMessage);
      }
      throw err;
    }
  }

  /**
   * List all group members
   * @param groupId   The group to list the members
   * @param first     The first offset result
   * @param max       The max results for the list. Defaults to 100
   */
  async listGroupMembers(groupId: string, first: number = 0, max: number = 100): Promise<UserRepresentation []> {
    const { data } = await this.server.get(`/admin/realms/${this.realm}/groups/${groupId}/members`, {
      params: { first, max }
    });
    return data;
  }

  /**
   * Adds a new user to the group
   * @param groupId   The group to add the user into
   * @param userId    The user to be added to the group
   */
  async addUser(groupId: string, userId: string): Promise<void> {
    await this.server.put(`/admin/realms/${this.realm}/users/${userId}/groups/${groupId}`);
  }

  /**
   * Removes an user from the group
   * @param groupId   The group to remove the user from
   * @param userId    The user to be removed from the group
   */
  async removeUser(groupId: string, userId: string): Promise<void> {
    await this.server.delete(`/admin/realms/${this.realm}/users/${userId}/groups/${groupId}`);
  }

  /**
   * Will assign a realm role to the group with the given ID
   * @param groupId
   * @param role
   */
  async addRealmRole(groupId: string, role: RoleRepresentation|RoleRepresentation []): Promise<void> {
    const roles: RoleRepresentation [] = Array.isArray(role) ? role : [role];
    await this.server.post(`/admin/realms/${this.realm}/groups/${groupId}/role-mappings/realm`, roles);
  }

  /**
   * Will return all realm roles from the group with the given ID
   * @param groupId
   */
  async getRealmRoles(groupId: string): Promise<RoleRepresentation []> {
    const { data } = await this.server.get(`/admin/realms/${this.realm}/groups/${groupId}/role-mappings/realm`);
    return data;
  }

  /**
   * Will remove a realm role from the group with the given ID
   * @param groupId
   * @param role
   */
  async removeRealmRole(groupId: string, role: RoleRepresentation|RoleRepresentation []): Promise<void> {
    const roles: RoleRepresentation [] = Array.isArray(role) ? role : [role];
    await this.server.delete(`/admin/realms/${this.realm}/groups/${groupId}/role-mappings/realm`, {
      data: roles
    });
  }
}

export const keycloakGroupService = new KeycloakGroupService(keycloakClient);