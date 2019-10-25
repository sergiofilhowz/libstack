import uuidv4 from 'uuid/v4';
import { NotFoundError } from '@libstack/server';
import { Person } from '../sequelize/Person';
import personModel, { PersonCriteria, PersonResponse, PersonSingleCriteria } from '../models/PersonModel';

interface PersonRequest {
  first_name: string;
  last_name: string;
  age: number;
}

class PersonService {

  async create(request:PersonRequest):Promise<PersonResponse> {
    const id = uuidv4();
    const model = Person.build({ id });
    model.first_name = request.first_name;
    model.last_name = request.last_name;
    model.age = request.age;
    await model.save();

    return this.get(id);
  }

  async deletePerson(id:string):Promise<void> {
    const model = await PersonService.findOne(id);
    await model.destroy();
  }

  async update(id:string, request:PersonRequest):Promise<PersonResponse> {
    const model = await PersonService.findOne(id);

    model.first_name = request.first_name;
    model.last_name = request.last_name;
    model.age = request.age;

    await model.save();
    return this.get(id);
  }

  async list(query:any):Promise<Array<PersonResponse>> {
    return personModel.list({
      projection: PersonResponse,
      criteria: {
        reference: PersonCriteria,
        query
      }
    });
  }

  async get(id:string):Promise<PersonResponse> {
    const model = await personModel.single({
      projection: PersonResponse,
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

  private static async findOne(id:string):Promise<Person> {
    const model = await Person.findOne({ where: { id } });
    if (!model) {
      throw new NotFoundError('Person not Found');
    }
    return model;
  }
}

export default new PersonService();
