import uuidv4 from 'uuid/v4';
import { NotFoundError } from '@libstack/server';
import { PersonEntity } from '../sequelize/PersonEntity';
import personModel, { PersonQuery, Person, PersonSingleCriteria } from '../models/PersonModel';
import { Field, InputType } from 'type-graphql';
import { Length } from 'class-validator';

@InputType({ description: 'Person request' })
export class PersonRequest {

  @Field({ nullable: false })
  @Length(6, 64)
  firstName: string;

  @Field({ nullable: false })
  @Length(6, 64)
  lastName: string;

  @Field({ nullable: false })
  age: number;
}

class PersonService {

  async create(request:PersonRequest):Promise<Person> {
    const id = uuidv4();
    const model = PersonEntity.build({ id });
    model.firstName = request.firstName;
    model.lastName = request.lastName;
    model.age = request.age;
    await model.save();

    return this.get(id);
  }

  async deletePerson(id:string):Promise<Person> {
    const model = await PersonService.findOne(id);
    const result: Person = await this.get(id);
    await model.destroy();
    return result;
  }

  async update(id:string, request:PersonRequest):Promise<Person> {
    const model = await PersonService.findOne(id);

    model.firstName = request.firstName;
    model.lastName = request.lastName;
    model.age = request.age;

    await model.save();
    return this.get(id);
  }

  async list(query:any):Promise<Array<Person>> {
    return personModel.list({
      projection: Person,
      criteria: {
        reference: PersonQuery,
        query
      }
    });
  }

  async get(id:string):Promise<Person> {
    const model = await personModel.single({
      projection: Person,
      criteria: {
        reference: PersonSingleCriteria,
        query: { id }
      }
    });
    if (!model) {
      throw new NotFoundError('Person not Found');
    }
    return model;
  }

  private static async findOne(id:string):Promise<PersonEntity> {
    const model = await PersonEntity.findOne({ where: { id } });
    if (!model) {
      throw new NotFoundError('Person not Found');
    }
    return model;
  }
}

export default new PersonService();
