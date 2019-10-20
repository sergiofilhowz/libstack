import { Model, Property, Projection, Criteria } from '../..';
import { EQUAL } from '../../lib/operator';
import { Person } from '../sequelize/Person';

@Projection
export class AddressResponse {
  @Property uuid: string;
  @Property street: string;
  @Property number: number;
}

@Projection({ sorted: true })
export class PersonResponse {
  @Property uuid: string;
  @Property first_name: string;
  @Property last_name: string;
  @Property address: AddressResponse;
}

class PersonCriteria {
  @Criteria({ property: 'first_name', operator: EQUAL })
  firstName?: string;

  @Criteria({ property: 'last_name', operator: EQUAL })
  lastName?: string;

  @Criteria({ operator: EQUAL })
  age?: number;
}

class PersonSingleCriteria {
  @Criteria({ operator: EQUAL })
  uuid: string;
}

class PersonModel extends Model {
  constructor() {
    super(Person);
  }

  getList(query:PersonCriteria):Promise<Array<PersonResponse>> {
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