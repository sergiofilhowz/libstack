import { expect } from 'chai';
import createUuid from 'uuid/v4';
import database from './database';
import { Person } from './sequelize/Person';
import { Address } from './sequelize/Address';
import PersonModel, { PersonAddressResponse, PersonResponse } from './models/PersonModel';
import { City } from './sequelize/City';

describe('Model', () => {
  before(() => database.sync({ clear: true }));

  let city:City;
  let address:Address;
  let person:Person;

  before(async () => {
    city = await City.create({
      uuid: createUuid(),
      name: 'Washington DC',
    });

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
    expect(projection.properties[0]).to.have.property('modelProperty').equal('uuid');
    expect(projection.properties[0]).to.have.property('projectionProperty').equal('uuid');
  });

  it('should get list of people', async () => {
    const result:Array<PersonResponse> = await PersonModel.getList({});

    expect(result).with.length(1);
    expect(result[0]).to.have.property('uuid').equal(person.uuid);
    expect(result[0]).to.have.property('first_name').equal(person.first_name);
    expect(result[0]).to.have.property('last_name').equal(person.last_name);
    expect(result[0]).to.have.property('age').equal(person.age);

    const addressExpect = expect(result[0]).to.have.property('address');
    addressExpect.to.have.property('uuid').equal(address.uuid);
    addressExpect.to.have.property('street').equal(address.street);
    addressExpect.to.have.property('number').equal(address.number);

    const cityExpect = addressExpect.to.have.property('city');
    cityExpect.to.have.property('uuid').equal(city.uuid);
    cityExpect.to.have.property('name').equal(city.name);
  });

  it('should get list of people with transform on field', async () => {
    const result:Array<PersonResponse> = await PersonModel.getList({});
    expect(result).with.length(1);
    expect(result[0]).to.have.property('adult').equal(true);
  });

  it('should filter with criteria equal', async () => {
    let result = await PersonModel.getList({ firstName: 'Sergio' });
    expect(result).with.length(1);

    result = await PersonModel.getList({ firstName: 'Sergioo' });
    expect(result).with.length(0);
  });

  it('should return values on a Projection with properties from an association', async () => {
    let result:Array<PersonAddressResponse> = await PersonModel.getPersonAddresses();

    expect(result).with.length(1);
    expect(result[0]).to.have.property('address_uuid').equal(address.uuid);
    expect(result[0]).to.have.property('address_street').equal(address.street);
    expect(result[0]).to.have.property('address_number').equal(address.number);
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
