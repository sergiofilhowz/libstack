import { GET, POST, PUT, RestController } from '@libstack/server';
import { Request } from 'express';
import { DELETE } from '@libstack/router';

@RestController('/sample-router')
class TestRouter {

  @GET('/')
  async get({ query, headers }: Request):Promise<any> {
    return { query, headers };
  }

  @PUT('/')
  async put({ body }: Request):Promise<any> {
    return { body };
  }

  @POST('/')
  async post({ body }: Request):Promise<any> {
    return { body };
  }

  @DELETE('/')
  async deletee():Promise<any> {
    return { message: 'Deleted!' };
  }

}
