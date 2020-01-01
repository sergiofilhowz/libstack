import { expect } from 'chai';
import createUuid from 'uuid/v4';
import database from './database';
import { Person } from './sequelize/Person';
import { Address } from './sequelize/Address';
import PersonModel, {
  PersonAddressResponse,
  PersonCriteria,
  PersonResponse,
  PersonSingleCriteria
} from './models/PersonModel';
import { City } from './sequelize/City';
import { Page } from '../lib/model';

describe('Model', () => {
  before(() => database.sync({ clear: true }));

  let city:City;
  let address:Address;
  let person:Person;

  let anotherAddress:Address;
  let anotherPerson:Person;

  before(async () => {
    city = await City.create({
      uuid: createUuid(),
      name: 'Washington DC',
    });

    address = await Address.create({
      uuid: createUuid(),
      street: '5th Street',
      number: 108,
      city_id: city.id,
    });
    person = await Person.create({
      uuid: createUuid(),
      firstName: 'Sergio',
      lastName: 'Marcelino',
      age: 30,
      address_id: address.id
    });
    expect(person).to.have.property('id');

    anotherAddress = await Address.create({
      uuid: createUuid(),
      street: '3rd Avenue',
      number: 854,
      city_id: city.id
    });
    anotherPerson = await Person.create({
      uuid: createUuid(),
      firstName: 'John',
      lastName: 'Doe',
      age: 15,
      address_id: anotherAddress.id
    });
    expect(anotherPerson).to.have.property('id');
  });

  it('should have a projection mapping', () => {
    const projection = Reflect.getMetadata('projection', PersonResponse);
    expect(projection.properties[0]).to.have.property('modelProperty').equal('uuid');
    expect(projection.properties[0]).to.have.property('projectionProperty').equal('uuid');
  });

  it('should get list of people', async () => {
    const result:Array<PersonResponse> = await PersonModel.list({
      projection: PersonResponse
    });

    expect(result).with.length(2);
    expect(result[0]).to.have.property('uuid').equal(person.uuid);
    expect(result[0]).to.have.property('firstName').equal(person.firstName);
    expect(result[0]).to.have.property('lastName').equal(person.lastName);
    expect(result[0]).to.have.property('age').equal(person.age);
    expect(result[0]).to.have.property('address').to.have.property('uuid').equal(address.uuid);
    expect(result[0]).to.have.property('address').to.have.property('street').equal(address.street);
    expect(result[0]).to.have.property('address').to.have.property('number').equal(address.number);
    expect(result[0]).to.have.property('address').to.have.property('city').to.have.property('uuid').equal(city.uuid);
    expect(result[0]).to.have.property('address').to.have.property('city').to.have.property('name').equal(city.name);

    expect(result[1]).to.have.property('uuid').equal(anotherPerson.uuid);
    expect(result[1]).to.have.property('firstName').equal(anotherPerson.firstName);
    expect(result[1]).to.have.property('lastName').equal(anotherPerson.lastName);
    expect(result[1]).to.have.property('age').equal(anotherPerson.age);
    expect(result[1]).to.have.property('address').to.have.property('uuid').equal(anotherAddress.uuid);
    expect(result[1]).to.have.property('address').to.have.property('street').equal(anotherAddress.street);
    expect(result[1]).to.have.property('address').to.have.property('number').equal(anotherAddress.number);
    expect(result[1]).to.have.property('address').to.have.property('city').to.have.property('uuid').equal(city.uuid);
    expect(result[1]).to.have.property('address').to.have.property('city').to.have.property('name').equal(city.name);
  });

  it('should get page of people', async () => {
    const result:Page<PersonResponse> = await PersonModel.page({
      pageSize: 1,
      page: 1,
      projection: PersonResponse,
    });

    expect(result).to.have.property('list').with.length(1);
    expect(result).to.have.property('count').equal(2);
    expect(result).to.have.property('page').equal(1);
    expect(result).to.have.property('pages').equal(2);
  });

  it('should get list of people with transform on field', async () => {
    const result:Array<PersonResponse> = await PersonModel.list({
      projection: PersonResponse
    });
    expect(result).with.length(2);
    expect(result[0]).to.have.property('adult').equal(true);
    expect(result[1]).to.have.property('adult').equal(false);
  });

  it('should return values on a Projection with properties from an association', async () => {
    let result:Array<PersonAddressResponse> = await PersonModel.list({ projection: PersonAddressResponse });

    expect(result).with.length(2);
    expect(result[0]).to.have.property('addressUuid').equal(address.uuid);
    expect(result[0]).to.have.property('addressStreet').equal(address.street);
    expect(result[0]).to.have.property('addressNumber').equal(address.number);
  });

  it('should get a single person', async () => {
    let result:PersonResponse = await PersonModel.single({
      projection: PersonResponse,
      criteria: {
        reference: PersonSingleCriteria,
        query: { uuid: person.uuid }
      }
    });

    expect(result).to.not.be.null;
    expect(result).to.have.property('uuid').equal(person.uuid);
    expect(result).to.have.property('firstName').equal(person.firstName);
    expect(result).to.have.property('lastName').equal(person.lastName);
    expect(result).to.have.property('age').equal(person.age);

    const addressExpect = expect(result).to.have.property('address');
    addressExpect.to.have.property('street').equal(address.street);
    addressExpect.to.have.property('number').equal(address.number);

    result = await PersonModel.single({
      projection: PersonResponse,
      criteria: {
        reference: PersonSingleCriteria,
        query: { uuid: '65f91139-1a1d-46fe-a743-59d307a55dd6' }
      }
    });
    expect(result).to.be.null;
  });

  describe('Sort', () => {

    it('should sort by property on projection', async () => {
      let result = await PersonModel.list({
        projection: PersonResponse,
        sort: 'firstName'
      });
      expect(result).with.length(2);
      expect(result[0]).to.have.property('firstName').equal(anotherPerson.firstName);
      expect(result[1]).to.have.property('firstName').equal(person.firstName);

      result = await PersonModel.list({
        projection: PersonResponse,
        sort: '-firstName'
      });
      expect(result).with.length(2);
      expect(result[0]).to.have.property('firstName').equal(person.firstName);
      expect(result[1]).to.have.property('firstName').equal(anotherPerson.firstName);
    });

  });

  describe('Criteria', () => {
    it('should filter with criteria ILIKE', async () => {
      let result = await PersonModel.list({
        projection: PersonResponse,
        criteria: {
          reference: PersonCriteria,
          query: { firstName: 'Sergio' }
        }
      });
      expect(result).with.length(1);

      result = await PersonModel.list({
        projection: PersonResponse,
        criteria: {
          reference: PersonCriteria,
          query: { firstName: 'Sergioo' }
        }
      });
      expect(result).with.length(0);
    });

    it('should filter with criteria ILIKE on subproperty', async () => {
      let result = await PersonModel.list({
        projection: PersonResponse,
        criteria: {
          reference: PersonCriteria,
          query: { city: 'wash' }
        }
      });
      expect(result).with.length(2);

      result = await PersonModel.list({
        projection: PersonResponse,
        criteria: {
          reference: PersonCriteria,
          query: { city: 'San Francisco' }
        }
      });
      expect(result).with.length(0);
    });

    it('should filter with criteria GREATER_THAN with flag field', async () => {
      let result = await PersonModel.list({
        projection: PersonResponse,
        criteria: {
          reference: PersonCriteria,
          query: { adultsOnly: true }
        }
      });
      expect(result).with.length(1);
      expect(result[0]).to.have.property('firstName').equal(person.firstName);

      result = await PersonModel.list({
        projection: PersonResponse,
        criteria: {
          reference: PersonCriteria,
          query: { kidsOnly: true }
        }
      });
      expect(result).with.length(1);
      expect(result[0]).to.have.property('firstName').equal(anotherPerson.firstName);
    });

    it('should filter with criteria IN with and without values', async () => {
      let result = await PersonModel.list({
        projection: PersonResponse,
        criteria: {
          reference: PersonCriteria,
          query: { ageIn: [15, 19] }
        }
      });
      expect(result).with.length(1);
      expect(result[0]).to.have.property('age').equal(anotherPerson.age);

      result = await PersonModel.list({
        projection: PersonResponse,
        criteria: {
          reference: PersonCriteria,
          query: { ageIn: [] }
        }
      });
      expect(result).with.length(0);
    });
  });

});
