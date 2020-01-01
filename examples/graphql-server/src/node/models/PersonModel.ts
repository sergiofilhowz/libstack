import { DataModel, Property, Projection, Criteria, Operators } from '@libstack/data';
import { PersonEntity } from '../sequelize/PersonEntity';
import { ArgsType, Field, Int, ObjectType } from 'type-graphql';

const { EQUAL, GREATER_THAN, ILIKE, LESS_THAN } = Operators;

const isPersonAdult = (value:number):boolean => value >= 18;

@Projection
@ObjectType()
export class Person {
  @Field({ description: 'Person ID' })
  @Property id: string;

  @Field({ description: 'Person first name' })
  @Property firstName: string;

  @Field({ description: 'Person last name' })
  @Property lastName: string;

  @Field(type => Int, { description: 'Person age'})
  @Property age: number;

  @Field({ description: 'Wether the person is 18+ or not' })
  @Property({ property: 'age', transform: isPersonAdult })
  adult: boolean;
}

@ArgsType()
export class PersonQuery {
  @Field({ nullable: true, description: 'Search by first name' })
  @Criteria({ property: 'firstName', operator: ILIKE })
  firstName?: string;

  @Field(type => Int, { nullable: true, description: 'Filter by age equal' })
  @Criteria({ operator: EQUAL })
  age?: number;

  @Field({ nullable: true, description: 'Filter people with age above 18' })
  @Criteria({ operator: GREATER_THAN, property: 'age', value: 18 })
  adultsOnly?:boolean;

  @Field({ nullable: true, description: 'Filter people with age less than 18' })
  @Criteria({ operator: LESS_THAN, property: 'age', value: 18 })
  kidsOnly?:boolean;
}

export class PersonSingleCriteria {
  @Criteria({ operator: EQUAL })
  id: string;
}

class PersonModel extends DataModel {
  constructor() {
    super(PersonEntity);
  }
}

export default new PersonModel();