---
id: libstack-keycloak
title: @libstack/keycloak
sidebar_label: @libstack/keycloak
---

Adds keycloak integration to your `@libstack/server`.

## Installing

```
npm install @libstack/keycloak --save
```

## New env variables
>- `KEYCLOAK_ENABLED`: Must be true to enable the integration
>- `KEYCLOAK_AUTH_URL`: This is the auth url for keycloak authorization
>- `KEYCLOAK_CLIENT_ID`: The client ID to use
>- `KEYCLOAK_CLIENT_SECRET`: The client Secret to use
>- `KEYCLOAK_REALM`: The keycloak realm

## Integrate to your routes
In order to enable integration, your routes need to have a custom property `{ roles: ['admin'] }`
Where roles will be the client resource roles.

So, we recommend on creating realm-roles on your keycloak and having them as composite with the client roles.
You will assign the realm-roles to your users.

### Sample code

```typescript
import { GET, RestController } from '@libstack/server';

@RestController('/v1/test')
class TestRouter {

  @GET('/unauthorized')
  async unauthorizedRoute():Promise<any> {
    return { authorized: false };
  }

  @GET('/authorized', { roles: ['admin'] })
  async authorizedRoute():Promise<any> {
    return { authorized: true };
  }
}
```

And then you will need to enable the keycloak interceptor on your application by just importing the keycloak module.

## Plug in the keycloak interceptor on your application

```typescript
import '@libstack/keycloak';
```

## Creating users and groups

Keycloak service has users and groups which you can manage as you want. 

**Important note:**

To be able to perform those actions your client will need to have `service account roles` enabled and will need to have permission `realm-admin` on `realm-management` , otherwise you will see some 403 errors.

### User Service

`@libstack/keycloak` has a class to manage users for your application. All you will need to do is import `keycloakUserService`.

```typescript
import { keycloakUserService } from '@libstack/keycloak';
```

#### User service methods

Here are the methods available on user service

##### Create User

There is one method to create users. It will return the `userId` from keycloak, store it on the record you want to link with the user.

```typescript
async createUser(user: UserRepresentation): Promise<string>
```

This method throws `UserCreationError` when the username or email is already being used.

##### Update User

There is one method to update an user. You need to provide the `userId` to perform the update and the data you want to change.

```typescript
async updateUser(userId: string, user: UserRepresentation): Promise<void>
```

This method also throws `UserCreationError` when the new username or email is already being used.

##### Get User

There is one method to return user data. You need to provide the `userId` from the user.

```typescript
async getUser(userId: string): Promise<UserRepresentation>
```

##### Delete User

There is one method to delete the user from keycloak (along with his/her access to the application).

```typescript
async deleteUser(userId: string): Promise<void>
```

##### Reset user password

You can also reset the user's password by calling the method described below.

```typescript
async resetUserPassword(userId: string, password: string, temporary: boolean = false)
```

If you set the temporary flag to `true`, once the user logs in into the application, he will be asked to change the password imediatelly.

##### Send email to user with required actions

There is one method to send emails with required actions, and they are: 

* Update password
* Configure OTP (One time password)
* Verify email
* Update user profile (first name, last name and email)

```typescript
async executeActionsEmail(userId: string, payload: ActionsEmail)
```

You will need to also provide the `redirectUri` and `clientId` so the user will be automatically redirected to your frontend application once he finishes the configuration.

### Group Service

In keycloak, groups are more related to the user's permissions. So, instead of assigning roles directly to the users, it's recommended to create a group, assign the roles to it and then add users to the group, this way will give more controls on all users on a given profile.

`@libstack/keycloak` has a class to manage groups for your application. All you will need to do is import `keycloakGroupService`.

```typescript
import { keycloakGroupService } from '@libstack/keycloak';
```

#### Group service methods

Here are the methods available on user service

##### Create Group

There is one method to create groups. It will return the `groupId` from keycloak, store it on the record you want to link with the group.

```typescript
async createGroup(group: GroupRepresentation): Promise<string>
```

This method throws GroupCreationError when the group name is already being used.

##### Update Group

There is one method to update a group. You need to provide the `groupId` to perform the update and the data you want to change.

```typescript
async updateGroup(groupId: string, group: GroupRepresentation): Promise<void>
```

This method also throws `GroupCreationError` when the group name is already being used.

##### Get Group

There is one method to return group data. You need to provide the `groupId` from the group.

```typescript
async getGroup(groupId: string): Promise<GroupRepresentation>
```

##### Delete Group

There is one method to delete the group from keycloak, but it **won't** delete any users inside of it. If you want to do so, you will need to delete all users manually.

```typescript
async deleteUser(userId: string): Promise<void>
```

##### Listing Group members

You can list all group members by just providing the `groupId`.

```typescript
async listGroupMembers(groupId: string, first: number = 0, max: number = 100): Promise<UserRepresentation []>
```

##### Adding users to the group

To add new users to the group, you just need to pass the `groupId` and the `userId`.

```typescript
async addMember(groupId: string, userId: string): Promise<void>
```

##### Removing users from the group

To remove users from the group, you just need to pass the `groupId` and the `userId` present on the group.

```typescript
async removeMember(groupId: string, userId: string): Promise<void>
```

##### Adding/Removing realm roles to the group

So you can create groups and add users to them, but you will need to assign roles to the groups so users will indirectly have those roles. In order to do so, you need to get the realm role by using the `keycloakClient` and then you can assign the roles to the group.

```typescript
async addRealmRole(groupId: string, role: RoleRepresentation|RoleRepresentation []): Promise<void>;

async removeRealmRole(groupId: string, role: RoleRepresentation|RoleRepresentation []): Promise<void>;
```

The code below will show how to do this:

```typescript
import { 
  keycloakClient, 
  keycloakGroupService, 
  RoleRepresentation
} from '@libstack/keycloak';

async function addRoleToGroup(groupId: string, roleName: string) {
  const role: RoleRepresentation = await keycloakClient.getRealmRole(roleName);
  await keycloakGroupService.addRealmRole(groupId, role);
}

async function removeRoleFromGroup(groupId: string, roleName: string) {
  const role: RoleRepresentation = await keycloakClient.getRealmRole(roleName);
  await keycloakGroupService.removeRealmRole(groupId, role);
}
```

### Using session user from Keycloak

In order to use the session user from Keycloak you will need to make sure the route is authenticated and you must use the `KeycloakRequest` on the Express route.

```typescript
import { GET, RestController } from '@libstack/server';
import { KeycloakRequest } from '@libstack/keycloak';

@RestController('/v1/test')
class TestRouter {

  @GET('/authorized', { roles: ['admin'] })
  async authorizedRoute(request: KeycloakRequest):Promise<any> {
    return { username: request.session?.username };
  }
}
```

If you want to get more details from the user, like the user's attributes, you will need to use `keycloakUserService`.