import uuidv4 from 'uuid/v4';
import { NotFoundError } from '@libstack/server';
import { Person } from '../sequelize/Person';

interface PersonRequest {
  first_name: string;
  last_name: string;
  age: number;
}

class PersonService {

  async create(request:PersonRequest) {
    const model = Person.build({ id: uuidv4() });
    model.first_name = request.first_name;
    model.last_name = request.last_name;
    model.age = request.age;
    return model.save();
  }

  async deletePerson(id:string) {
    const model = await this.findOne(id);
    return model.destroy();
  }

  async update(id:string, request:PersonRequest) {
    const model = await this.findOne(id);

    model.first_name = request.first_name;
    model.last_name = request.last_name;
    model.age = request.age;

    return model.save();
  }

  async list() {
    return Person.findAll();
  }

  async findOne(id:string) {
    const model = await Person.findOne({ where: { id } });
    if (!model) {
      throw new NotFoundError('Person not Found');
    }
    return model;
  }
}

export default new PersonService();
