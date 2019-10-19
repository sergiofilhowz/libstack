import { Model } from './model';
import { Projection } from './projection';
import { Property } from './property';
import { Criteria } from './criteria';
import { EQUAL } from './operator';

@Projection
class AddressResponse {
  @Property
  street: string;
}

@Projection({ sorted: true })
class PersonResponse {
  @Property
  name: string;

  @Property
  last_name: string;

  @Property({ property: 'Address' })
  address: AddressResponse;
}

class PersonCriteria {
  @Criteria({ property: 'name', operator: EQUAL })
  name?: string;

  @Criteria({ property: 'last_name', operator: EQUAL })
  lastName?: string;
}

class PersonModel extends Model {
  constructor() {
    // use a real model here
    super(null/*Person*/);
  }

  getList(query:PersonCriteria):Promise<Array<PersonResponse>> {
    return this.list({
      projection: PersonResponse,
      criteria: query
    });
  }
}
