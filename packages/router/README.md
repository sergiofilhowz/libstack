# @libstack/router
An extreme powerful Express Routing machine

## What is it ?
This module adds the async/await to your express app.
In addition to promise, you can add endpoint configurations so you can intercept the request and do
everything you want.

## Usage
```typescript
import express, { Request, Response } from 'express';
import controller, { RestController, GET, POST, BadRequestError, CallableStack, Interceptor, RestInterceptor } from '@libstack/router';

const app = express();

@RestInterceptor
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
  async get() {
    const result = await someModule.execAsyncCall();
    return result; 
  }

  @GET('/customEnd')
  async customEnd(req:Request, res:Response) {
    res.end('my custom end');
  }

  @POST('/throwError')
  async throwError() {
    throw new BadRequestError('My error message');
  }
}

app.use(controller.router); // use plugin the @libstack/router to your express app
app.listen(process.env.PORT || 8080);
```