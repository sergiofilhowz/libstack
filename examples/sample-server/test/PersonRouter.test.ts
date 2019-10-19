import TestHelper from './TestHelper';
import { database } from '@libstack/sequel';

const { http, expect } = TestHelper;
const { get, post, put } = http;

describe('PersonRouter', () => {
  before(() => database.sync({ clear: true }));

  it('should list people', async () => {
    const response = await get('/v1/person');
    expect(response.status).to.be.equal(200);
    expect(response.body).with.length(0);
  });

  it('should create a person', async () => {
    const response = await post('/v1/person', {
      first_name: 'Sergio',
      last_name: 'Marcelino',
      age: 30
    });
    expect(response.status).to.be.equal(200);
    expect(response.body).to.have.property('first_name').equal('Sergio');
  });

});
