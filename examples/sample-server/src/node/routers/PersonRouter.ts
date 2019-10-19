import { GET, POST, PUT, DELETE, RestController } from '@libstack/server';
import personService from '../services/PersonService';
import { Request } from 'express';
import { Person } from '../sequelize/Person';

@RestController('/v1/person')
export default class PersonRouter {

  @GET('/')
  async listPerson():Promise<Array<Person>> {
    return personService.list();
  }

  @GET('/:id')
  async findPerson({ params }:Request):Promise<Person> {
    return personService.findOne(params.id);
  }

  @POST('/')
  async createPerson(request:Request):Promise<Person>{
    return personService.create(request.body);
  }

  @PUT('/:id')
  async updatePerson(request:Request):Promise<Person> {
    return personService.update(request.params.id, request.body);
  }

  @DELETE('/:id')
  async deletePerson(request:Request):Promise<void> {
    await personService.deletePerson(request.params.id);
  }

}
