import {
  RoleRepresentation,
  GroupRepresentation,
  UserRepresentation
} from '..';
import { keycloakClient } from '../lib/keycloak';
import { keycloakUserService } from '../lib/keycloakUser';
import { keycloakGroupService } from '../lib/keycloakGroup';
import TestHelper from './TestHelper';

const { expect } = TestHelper;

const groupRep: GroupRepresentation = {
  name: 'My Lovely Group',
  attributes: { lovers: ['150'] }
};

const userRep: UserRepresentation = {
  email: 'email@example.com',
  firstName: 'First',
  lastName: 'Last',
  username: 'username',
};

describe('KeycloakGroupService', () =>{

  it('should create update and delete group', async () => {
    const groupId: string = await keycloakGroupService.createGroup(groupRep);
    const group: GroupRepresentation = await keycloakGroupService.getGroup(groupId);

    expect(group.name).equal(groupRep.name);
    expect(group.attributes).to.have.property('lovers').deep.equal(['150']);

    await keycloakGroupService.updateGroup(groupId, {
      name: 'Not so lovely group',
      attributes: {
        haters: ['10'],
        lovers: ['0']
      }
    });
    const updatedGroup: GroupRepresentation = await keycloakGroupService.getGroup(groupId);
    expect(updatedGroup.attributes).to.have.property('haters').deep.equal(['10']);
    expect(updatedGroup.attributes).to.have.property('lovers').deep.equal(['0']);

    expect(updatedGroup.name).equal('Not so lovely group');

    await keycloakGroupService.deleteGroup(groupId);
  });

  it('should assign realm roles to group', async () => {
    const groupId: string = await keycloakGroupService.createGroup(groupRep);
    const roles: RoleRepresentation [] = await keycloakGroupService.getRealmRoles(groupId);
    expect(roles).with.length(0);

    const role: RoleRepresentation = await keycloakClient.getRealmRole('libstack-tester');
    await keycloakGroupService.addRealmRole(groupId, role);

    const updatedRoles: RoleRepresentation [] = await keycloakGroupService.getRealmRoles(groupId);
    expect(updatedRoles).with.length(1);
    expect(updatedRoles[0].name).equal('libstack-tester');

    await keycloakGroupService.removeRealmRole(groupId, role);
    const updatedRoles2: RoleRepresentation [] = await keycloakGroupService.getRealmRoles(groupId);
    expect(updatedRoles2).with.length(0);

    await keycloakGroupService.deleteGroup(groupId);
  });

  it('should manage members on group', async () => {
    const groupId: string = await keycloakGroupService.createGroup(groupRep);
    const userId: string = await keycloakUserService.createUser(userRep);

    let members: UserRepresentation [] = await keycloakGroupService.listGroupMembers(groupId);
    expect(members).with.length(0);

    await keycloakGroupService.addUser(groupId, userId);

    members = await keycloakGroupService.listGroupMembers(groupId);
    expect(members).with.length(1);
    expect(members[0].id).equal(userId);

    await keycloakGroupService.removeUser(groupId, userId);

    members = await keycloakGroupService.listGroupMembers(groupId);
    expect(members).with.length(0);

    await keycloakGroupService.deleteGroup(groupId);
    await keycloakUserService.deleteUser(userId);
  });

  it('should return a readable error when name exists', async () => {
    const groupId: string = await keycloakGroupService.createGroup(groupRep);

    try {
      await expect(keycloakGroupService.createGroup(groupRep))
        .to.be.rejectedWith("Top level group named 'My Lovely Group' already exists.");
    } finally {
      await keycloakGroupService.deleteGroup(groupId);
    }
  });

});