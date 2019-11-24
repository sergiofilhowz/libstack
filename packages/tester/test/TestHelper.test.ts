import { testHelper, admin, user } from './test.helper';

const http = testHelper.http; // this HTTP will perform annonymous request
const httpAdmin = http.as(admin); // this HTTP will perform admin authenticated requests
const httpUser = http.as(user); // this HTTP will perform user authenticated requests
const { expect } = testHelper;

// who tests the tester ?
describe('Test Helper', () => {

  describe('Sample Router', () => {
    it('should return 200 on GET', async () => {
      const response = await http.get('/sample-router');
      expect(response.status).to.be.equal(200);
    });

    it('should return 200 on GET with queries', async () => {
      const query = { name: 'sergio' };
      // this request will be /sample-router?name=sergio
      const response = await http.get('/sample-router', { query });
      expect(response.status).to.be.equal(200);
      expect(response.body)
        .to.have.property('query')
        .to.have.property('name')
        .equal('sergio');
    });

    it('should return 200 on POST', async () => {
      const body = { message: 'anything' };
      const response = await http.post('/sample-router', body);
      expect(response.status).to.be.equal(200);
      expect(response.body)
        .to.have.property('body')
        .to.have.property('message')
        .equal('anything');
    });

    it('should return 200 on PUT', async () => {
      const body = { message: 'anything' };
      const response = await http.put('/sample-router', body);
      expect(response.status).to.be.equal(200);
      expect(response.body)
        .to.have.property('body')
        .to.have.property('message')
        .equal('anything');
    });

    it('should return 200 on DELETE', async () => {
      const response = await http.delete('/sample-router');
      expect(response.status).to.be.equal(200);
    });
  });

  describe('Decorator', () => {
    it('should perform user authenticated requests', async () => {
      let response = await httpUser.get('/sample-router');
      expect(response.status).to.be.equal(200);
      expect(response.body)
        .to.have.property('headers')
        .to.have.property('authorization')
        .equal('Bearer user-123456');

      response = await httpAdmin.get('/sample-router');
      expect(response.status).to.be.equal(200);
      expect(response.body)
        .to.have.property('headers')
        .to.have.property('authorization')
        .equal('Bearer admin-123456');
    });
  });

});