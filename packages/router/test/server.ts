import express, { Request, Response } from 'express';
import controller, {
  RestController,
  GET,
  POST,
  BadRequestError,
  CallableStack,
  Interceptor,
  RestInterceptor,
  NotFoundError
} from '../index';

const app = express();

@RestInterceptor()
class AddPropertyInterceptor implements Interceptor {
  intercepts(parameters:any):boolean {
    return parameters.addProperty;
  }

  async execute(parameters:any, req:Request, res:Response, stack:CallableStack) {
    const result = await stack.next();
    result.anotherResult = 'The result has been changed!';
    return result;
  }
}

@RestController('/myController')
class TestRouter {

  @GET('/', { addProperty: true })
  async get():Promise<{ result: string }> {
    return Promise.resolve({
      result: 'I can return a promise!'
    });
  }

  @GET('/customEnd')
  async customEnd(req:Request, res:Response) {
    res.end('my custom end');
  }

  @GET('/throw404')
  async throw404() {
    throw new NotFoundError('Pretend I don\'t exist');
  }

  @POST('/throwError')
  async throwError() {
    throw new BadRequestError('My error message');
  }
}

app.use(controller.router); // use plugin the powerRouter to your express app
app.listen(8876 || process.env.PORT);

export default app;