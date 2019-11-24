import { DataModel, Property, Projection, Criteria, Operators } from '@libstack/data';
import { Person } from '../sequelize/Person';

const { EQUAL, GREATER_THAN, ILIKE, LESS_THAN } = Operators;

const isPersonAdult = (value:number):boolean => value >= 18;

@Projection
export class PersonResponse {
  @Property id: string;
  @Property first_name: string;
  @Property last_name: string;
  @Property age: number;

  @Property({ property: 'age', transform: isPersonAdult })
  adult: boolean;
}

export class PersonCriteria {
  @Criteria({ property: 'first_name', operator: ILIKE })
  firstName?: string;

  @Criteria({ operator: EQUAL })
  age?: number;

  @Criteria({ operator: GREATER_THAN, property: 'age', value: 18 })
  adults_only?:boolean;

  @Criteria({ operator: LESS_THAN, property: 'age', value: 18 })
  kids_only?:boolean;
}

export class PersonSingleCriteria {
  @Criteria({ operator: EQUAL })
  id: string;
}

class PersonModel extends DataModel {
  constructor() {
    super(Person);
  }
}

export default new PersonModel();