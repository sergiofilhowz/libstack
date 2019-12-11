import { config } from '@libstack/server';
import TestHelper from './TestHelper';
import nock from 'nock';

const { http, expect } = TestHelper;
const { get } = http;

interface KeycloakMockConfig {
  valid: boolean;
  roles?: string [];
  returnCode?: number;
}
const mockKeycloakAuthorization = (mockConfig: KeycloakMockConfig) => {
  nock.cleanAll();
  const mock = nock(config.get('KEYCLOAK_AUTH_URL'));
  const realm: string = config.get('KEYCLOAK_REALM');
  const clientId: string = config.get('KEYCLOAK_CLIENT_ID');
  const response: any = mockConfig.valid ? {
      active: true,
      resource_access: {
        [clientId]: {
          roles: mockConfig.roles
        }
      }
    } : { active: false };

  const introspect: string = `/realms/${realm}/protocol/openid-connect/token/introspect`;
  mock.post(introspect).reply(mockConfig.returnCode ?? 200, response);
};

describe('Keycloak Interceptor', () => {

  after(() => nock.cleanAll());

  it('should return 200 on unauthorized route', async () => {
    const response = await get('/v1/test/unauthorized');
    expect(response.status).to.be.equal(200);
    expect(response.body).to.have.property('authorized').equal(false);
  });

  it('should return 401 on authorized route', async () => {
    mockKeycloakAuthorization({ valid: false });
    const response = await get('/v1/test/authorized');
    expect(response.status).to.be.equal(401);
    expect(response.body).to.have.property('message').equal('Not Authorized');
  });

  it('should return 200 on authorized route when authorization header is valid', async () => {
    mockKeycloakAuthorization({ valid: true, roles: ['admin'] });
    const response = await get('/v1/test/authorized', {
      headers: {
        Authorization: `Bearer Zng1MzR4Mng0eGYzZngyM2Y=`
      }
    });
    expect(response.status).to.be.equal(200);
    expect(response.body).to.have.property('authorized').equal(true);
  });

  it('should return 401 on authorized route when authorization header is invalid', async () => {
    mockKeycloakAuthorization({ valid: false });
    const response = await get('/v1/test/authorized', {
      headers: {
        Authorization: `Bearer Zng1MzR4Mng0eGYzZngyM2Y=`
      }
    });
    expect(response.status).to.be.equal(401);
    expect(response.body).to.have.property('message').equal('Not Authorized');
  });

  it('should return 403 on authorized route when authorization header is valid, but user doesn\'t have role', async () => {
    mockKeycloakAuthorization({ valid: true, roles: ['user'] });
    const response = await get('/v1/test/authorized', {
      headers: {
        Authorization: `Bearer Zng1MzR4Mng0eGYzZngyM2Y=`
      }
    });
    expect(response.status).to.be.equal(403);
    expect(response.body).to.have.property('message').equal('Not Authorized');
  });

});
