import { DataModel, Property, Projection, Criteria, Operators } from '../..';
import { Person } from '../sequelize/Person';

const { EQUAL, GREATER_THAN, ILIKE, LESS_THAN, IN } = Operators;

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

@Projection
export class TagResponse {
  @Property uuid: string;
  @Property name: string;
}

@Projection({ sorted: true })
export class PersonResponse {
  @Property uuid: string;
  @Property firstName: string;
  @Property lastName: string;
  @Property age: number;
  @Property address: AddressResponse;

  @Property({ property: 'age', transform: (value:number) => value >= 18 })
  adult: boolean;
}

@Projection({ sorted: true })
export class PersonCityResponse {
  @Property uuid: string;

  @Property({ property: 'address.city.name' })
  city: string;
}

@Projection
export class PersonAddressResponse {
  @Property({ property: 'address.uuid' })
  addressUuid: string;

  @Property({ property: 'address.street' })
  addressStreet: string;

  @Property({ property: 'address.number' })
  addressNumber: string;
}

export class PersonCriteria {
  @Criteria({ property: 'firstName', operator: ILIKE })
  firstName?: string;

  @Criteria({ property: 'address.city.name', operator: ILIKE })
  city?: string;

  @Criteria({ operator: EQUAL })
  age?: number;

  @Criteria({ operator: GREATER_THAN, property: 'age', value: 18 })
  adultsOnly?:boolean;

  @Criteria({ operator: LESS_THAN, property: 'age', value: 18 })
  kidsOnly?:boolean;

  @Criteria({ operator: IN, property: 'age' })
  ageIn?: number[]
}

export class PersonSingleCriteria {
  @Criteria({ operator: EQUAL })
  uuid: string;
}

class PersonModel extends DataModel {
  constructor() {
    super(Person);
  }
}

export default new PersonModel();