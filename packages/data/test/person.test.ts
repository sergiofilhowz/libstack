import { expect } from 'chai';
import createUuid from 'uuid/v4';
import database from './database';
import { Person } from './sequelize/Person';
import { Address } from './sequelize/Address';
import PersonModel, { PersonResponse } from './models/PersonModel';

describe('Model', () => {
  before(() => database.sync({ clear: true }));

  let address:Address;
  let person:Person;

  before(async () => {
    address = await Address.create({
      uuid: createUuid(),
      street: '5th Street',
      number: 108
    });
    person = await Person.create({
      uuid: createUuid(),
      first_name: 'Sergio',
      last_name: 'Marcelino',
      age: 30,
      address_id: address.id
    });
    expect(person).to.have.property('id');
  });

  it('should have a projection mapping', () => {
    const projection = Reflect.getMetadata('projection', PersonResponse);
    expect(projection.properties.get('uuid')).to.have.property('property').equal('uuid');
  });

  it('should get list of people', async () => {
    let result:Array<PersonResponse> = await PersonModel.getList({});

    expect(result).with.length(1);
    expect(result[0]).to.have.property('uuid').equal(person.uuid);
    expect(result[0]).to.have.property('first_name').equal(person.first_name);
    expect(result[0]).to.have.property('last_name').equal(person.last_name);
    expect(result[0]).to.have.property('age').equal(person.age);

    const addressExpect = expect(result[0]).to.have.property('address');
    addressExpect.to.have.property('street').equal(address.street);
    addressExpect.to.have.property('number').equal(address.number);

    result = await PersonModel.getList({ firstName: 'Sergio' });
    expect(result).with.length(1);

    result = await PersonModel.getList({ firstName: 'Sergioo' });
    expect(result).with.length(0);
  });

  it('should get a single person', async () => {
    const result:PersonResponse = await PersonModel.getSingle(person.uuid);

    expect(result).to.not.be.null;
    expect(result).to.have.property('uuid').equal(person.uuid);
    expect(result).to.have.property('first_name').equal(person.first_name);
    expect(result).to.have.property('last_name').equal(person.last_name);
    expect(result).to.have.property('age').equal(person.age);

    const addressExpect = expect(result).to.have.property('address');
    addressExpect.to.have.property('street').equal(address.street);
    addressExpect.to.have.property('number').equal(address.number);
  });

});
