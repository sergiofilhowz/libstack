import { GET, POST, PUT, DELETE, RestController } from '@libstack/server';
import personService from '../services/PersonService';
import { Request } from 'express';

@RestController('/v1/person')
export default class PersonRouter {

  @GET('/')
  async listPerson() {
    return personService.list();
  }

  @GET('/:id')
  async findPerson({ params }:Request) {
    return personService.findOne(params.id);
  }

  @POST('/')
  async createPerson(request:Request) {
    return personService.create(request.body);
  }

  @PUT('/:id')
  async updatePerson(request:Request) {
    return personService.update(request.params.id, request.body);
  }

  @DELETE('/:id')
  async deletePerson(request:Request) {
    await personService.deletePerson(request.params.id);
  }

}
