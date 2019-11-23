# Libstack Server - Keycloak Integration
Add keycloak integration to your `@libstack/server`.

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