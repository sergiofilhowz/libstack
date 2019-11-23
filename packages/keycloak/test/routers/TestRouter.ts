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
