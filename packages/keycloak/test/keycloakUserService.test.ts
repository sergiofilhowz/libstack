import { keycloakClient, RoleRepresentation, UserRepresentation } from '..';
import { keycloakUserService } from '../lib/keycloakUser';
import TestHelper from './TestHelper';
import chai from 'chai';
import chaiAsPromised from 'chai-as-promised';

chai.use(chaiAsPromised);

const { expect } = TestHelper;

const userRep: UserRepresentation = {
  email: 'email@example.com',
  firstName: 'First',
  lastName: 'Last',
  username: 'username',
  attributes: { lovers: ['1000'] }
};

describe('KeycloakUserService', () =>{

  it('should create update and delete user', async () => {
    const userId: string = await keycloakUserService.createUser(userRep);
    const user: UserRepresentation = await keycloakUserService.getUser(userId);

    expect(user.email).equal(userRep.email);
    expect(user.firstName).equal(userRep.firstName);
    expect(user.lastName).equal(userRep.lastName);
    expect(user.username).equal(userRep.username);
    expect(user.attributes).to.have.property('lovers').deep.equal(['1000']);

    await keycloakUserService.updateUser(userId, {
      ...userRep,
      firstName: 'FirstName',
      lastName: 'LastName',
      attributes: { lovers: ['10'] }
    });
    const updatedUser: UserRepresentation = await keycloakUserService.getUser(userId);

    expect(updatedUser.email).equal(userRep.email);
    expect(updatedUser.firstName).equal('FirstName');
    expect(updatedUser.lastName).equal('LastName');
    expect(updatedUser.username).equal(userRep.username);
    expect(updatedUser.attributes).to.have.property('lovers').deep.equal(['10']);

    await keycloakUserService.deleteUser(userId);
  });

  it('should assign realm roles to user', async () => {
    const userId: string = await keycloakUserService.createUser(userRep);
    const roles: RoleRepresentation [] = await keycloakUserService.getRealmRoles(userId);
    expect(roles).with.length(2); // offline_access and uma_authorization

    const role: RoleRepresentation = await keycloakClient.getRealmRole('libstack-tester');
    await keycloakUserService.addRealmRole(userId, role);

    const updatedRoles: RoleRepresentation [] = await keycloakUserService.getRealmRoles(userId);
    expect(updatedRoles).with.length(3);
    expect(updatedRoles[0].name).equal('libstack-tester');

    await keycloakUserService.removeRealmRole(userId, role);
    const updatedRoles2: RoleRepresentation [] = await keycloakUserService.getRealmRoles(userId);
    expect(updatedRoles2).with.length(2);

    await keycloakUserService.deleteUser(userId);
  });

  it('should reset user credentials', async () => {
    const userId: string = await keycloakUserService.createUser(userRep);
    await keycloakUserService.resetUserPassword(userId, 'qwe123', true);
    await keycloakUserService.deleteUser(userId);
  });

  it('should return a readable error when username or email is used', async () => {
    const userId: string = await keycloakUserService.createUser(userRep);
    const anotherUsername: UserRepresentation = { ...userRep, username: 'another_username' };
    const anotherEmail: UserRepresentation = { ...userRep, email: 'another@email.com' };

    await expect(keycloakUserService.createUser(anotherUsername)).to.be.rejectedWith('User exists with same email');
    await expect(keycloakUserService.createUser(anotherEmail)).to.be.rejectedWith('User exists with same username');
    await keycloakUserService.deleteUser(userId);
  });

});