import { GET, POST, PUT, DELETE, RestController } from '@libstack/server';
import personService from '../services/PersonService';
import { Request } from 'express';
import { PersonResponse } from '../models/PersonModel';

@RestController('/v1/person')
class PersonRouter {

  @GET('/')
  async listPerson(req:Request):Promise<Array<PersonResponse>> {
    return personService.list(req.query);
  }

  @GET('/:id')
  async findPerson({ params }:Request):Promise<PersonResponse> {
    return personService.get(params.id);
  }

  @POST('/')
  async createPerson(request:Request):Promise<PersonResponse>{
    return personService.create(request.body);
  }

  @PUT('/:id')
  async updatePerson(request:Request):Promise<PersonResponse> {
    return personService.update(request.params.id, request.body);
  }

  @DELETE('/:id')
  async deletePerson(request:Request):Promise<void> {
    await personService.deletePerson(request.params.id);
  }

}
