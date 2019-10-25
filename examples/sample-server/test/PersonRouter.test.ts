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

  it('should list with query', async () => {
    let response = await post('/v1/person', {
      first_name: 'Sergio',
      last_name: 'Marcelino',
      age: 30
    });
    expect(response.status).to.be.equal(200);

    response = await get('/v1/person', { query: { adults_only: true }});
    expect(response.status).to.be.equal(200);
    expect(response.body).with.length(1);

    response = await get('/v1/person',{ query: { kids_only: true } });
    expect(response.status).to.be.equal(200);
    expect(response.body).with.length(0);
  });

  it('should create a person', async () => {
    let response = await post('/v1/person', {
      first_name: 'Sergio',
      last_name: 'Marcelino',
      age: 30
    });
    expect(response.status).to.be.equal(200);
    expect(response.body).to.have.property('first_name').equal('Sergio');
    expect(response.body).to.have.property('last_name').equal('Marcelino');
    expect(response.body).to.have.property('age').equal(30);
    expect(response.body).to.have.property('adult').equal(true);

    const { id } = response.body;

    response = await get(`/v1/person/${id}`);
    expect(response.status).to.be.equal(200);
    expect(response.body).to.have.property('first_name').equal('Sergio');
    expect(response.body).to.have.property('last_name').equal('Marcelino');
    expect(response.body).to.have.property('age').equal(30);
  });

  it('should update a person', async () => {
    let response = await post('/v1/person', {
      first_name: 'Sergio',
      last_name: 'Marcelino',
      age: 30
    });
    expect(response.status).to.be.equal(200);

    const { id } = response.body;

    response = await put(`/v1/person/${id}`, {
      first_name: 'Sergio',
      last_name: 'Marcelino Filho',
      age: 15
    });
    expect(response.status).to.be.equal(200);
    expect(response.body).to.have.property('first_name').equal('Sergio');
    expect(response.body).to.have.property('last_name').equal('Marcelino Filho');
    expect(response.body).to.have.property('age').equal(15);
    expect(response.body).to.have.property('adult').equal(false);
  });

  it('should delete a person', async () => {
    let response = await post('/v1/person', {
      first_name: 'Sergio',
      last_name: 'Marcelino',
      age: 30
    });
    expect(response.status).to.be.equal(200);

    const { id } = response.body;

    response = await http.delete(`/v1/person/${id}`);
    expect(response.status).to.be.equal(200);

    response = await get(`/v1/person/${id}`);
    expect(response.status).to.be.equal(404);
  });

});
