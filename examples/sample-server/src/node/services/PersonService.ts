import uuidv4 from 'uuid/v4';
import { NotFoundError } from '@libstack/server';
import { Person } from '../sequelize/Person';

interface PersonRequest {
  first_name: string;
  last_name: string;
  age: number;
}

class PersonService {

  async create(request:PersonRequest):Promise<Person> {
    const model = Person.build({ id: uuidv4() });
    model.first_name = request.first_name;
    model.last_name = request.last_name;
    model.age = request.age;
    return model.save();
  }

  async deletePerson(id:string):Promise<void> {
    const model = await this.findOne(id);
    await model.destroy();
  }

  async update(id:string, request:PersonRequest):Promise<Person> {
    const model = await this.findOne(id);

    model.first_name = request.first_name;
    model.last_name = request.last_name;
    model.age = request.age;

    return model.save();
  }

  async list():Promise<Array<Person>> {
    return Person.findAll();
  }

  async findOne(id:string):Promise<Person> {
    const model = await Person.findOne({ where: { id } });
    if (!model) {
      throw new NotFoundError('Person not Found');
    }
    return model;
  }
}

export default new PersonService();
