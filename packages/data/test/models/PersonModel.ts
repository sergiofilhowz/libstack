import { Model, Property, Projection, Criteria, EQUAL, GREATER_THAN, ILIKE, LESS_THAN } from '../..';
import { Person } from '../sequelize/Person';

@Projection
export class CityResponse {
  @Property uuid: string;
  @Property name: string;
}

@Projection
export class AddressResponse {
  @Property uuid: string;
  @Property street: string;
  @Property number: number;
  @Property city: CityResponse;
}

@Projection({ sorted: true })
export class PersonResponse {
  @Property uuid: string;
  @Property first_name: string;
  @Property last_name: string;
  @Property age: number;
  @Property address: AddressResponse;

  @Property({ property: 'age', transform: (value:number) => value >= 18 })
  adult: boolean;
}

@Projection({ sorted: true })
export class PersonAddressResponse {
  @Property({ property: 'address.uuid' })
  address_uuid: string;

  @Property({ property: 'address.street' })
  address_street: string;

  @Property({ property: 'address.number' })
  address_number: string;
}

class PersonCriteria {
  @Criteria({ property: 'first_name', operator: ILIKE })
  firstName?: string;

  @Criteria({ property: 'address.city.name', operator: ILIKE })
  city?: string;

  @Criteria({ operator: EQUAL })
  age?: number;

  @Criteria({ operator: GREATER_THAN, property: 'age', value: 18 })
  adults_only?:boolean;

  @Criteria({ operator: LESS_THAN, property: 'age', value: 18 })
  kids_only?:boolean;
}

class PersonSingleCriteria {
  @Criteria({ operator: EQUAL })
  uuid: string;
}

class PersonModel extends Model {
  constructor() {
    super(Person);
  }

  getPersonAddresses():Promise<Array<PersonAddressResponse>> {
    return this.list({ projection: PersonAddressResponse });
  }

  getList(query?:PersonCriteria):Promise<Array<PersonResponse>> {
    return this.list({
      projection: PersonResponse,
      criteria: {
        reference: PersonCriteria,
        query: query
      }
    });
  }

  getSingle(uuid:string):Promise<PersonResponse> {
    return this.single({
      projection: PersonResponse,
      criteria: {
        reference: PersonSingleCriteria,
        query: { uuid }
      }
    });
  }
}

export default new PersonModel();