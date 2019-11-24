# @libstack/router
An extreme powerful Express Routing machine

## What is it ?
This module adds the async/await to your express app.
In addition to promise, you can add endpoint configurations so you can intercept the request and do
everything you want.

## Installation

```
npm install @libstack/router --save
```

## Usage

You can create routes and interceptors. Let's first take a look on how to create routers.

### Routers

Routers are entrypoints on your application, you can define one with multiple endpoints, which have the default start path from the router.

```typescript
import { RestController, GET, POST, BadRequestError } from '@libstack/router';
// Supported methods: GET, POST, PUT, DELETE

@RestController('/myController')
class TestRouter {

  // The second argument is used for Interceptors (will be described in the next section)
  @GET('/', { addProperty: true })
  async get() {
    const result = await someModule.execAsyncCall();
    return result; 
  }

  @GET('/customEnd')
  async customEnd(req:Request, res:Response) {
    res.end('my custom end');
    // you can define the response you want by just calling res.end (from the express)
  }

  @POST('/throwError')
  async throwError() {
    throw new BadRequestError('My error message');
    // this error, when thrown, will return a 400 status code with this structure
    // { "message": "My error message" }
  }
}
```

### Interceptors

So, what is exactly an interceptor? Interceptors are business logics that needs to be executed on specific endpoints or all endpoits, it's up to you. Examples of interceptors are:

* **Error Interceptor**: Interceptor to catch one specific Error and return data to the API
* **Validation Interceptor**: Catch body and check if the request is valid
* **Authentication Interceptor**: Used to allow only authenticated users
* **ACL Interceptor**: Used to allow only authenticated users that have roles to perform a request

Alright, so how can we create interceptors? So, let's give an example of interceptor that adds a property to the response body (just an example).

```typescript
import { Request, Response } from 'express';
import { UnauthorizedError, CallableStack, Interceptor, RestInterceptor } from '@libstack/router';
import { getUserData, User } from './MyUserService';

@RestInterceptor
class ChangeResponseInterceptor implements Interceptor {
  /**
    * This method will be called on every request and the parameters are defined
    * on the second argument on @GET @POST @PUT and @DELETE decorators
    */
  intercepts(parameters: any): boolean {
    // so, for example, we created an interceptor that intercepts ALL requests
    return true;
  }

  /**
    * This method will only be executed if the condition on `intercepts` is true
    */
  async execute(parameters: any, req: Request, res: Response, stack: CallableStack): Promise<any> {
    /*
     * What exactly is this stack?
     * This is the interceptor execution stack. All interceptors
     * are linked within the Callable Stack and in order to continue
     * the execution you need to call next(). If you don't call next() it will
     * halt the request stack.
     */
    const response: any = await stack.next();
    
    // here we are changing the response
    if (response) {
      response.hello = 'Hello World';
    }
    return response; // if you don't return, there will be no response
  }
}
```

### Errors

There are some predefined errors on the module

* `BadRequestError`: Will return `400`
* `NotFoundError`: Will return `404`
* `UnauthorizedError`: Will return `401`
* `ForbiddenError`: Will return `403`

But you can also create your own HTTP error by just extending `HttpError`

```typescript
import { HttpError } from '@libstack/router';

export class UnauthorizedError extends HttpError {
  constructor(message: string, data?: any) {
    super(message, 401, data);
  }
}
```

As you can see, there's a `data` property on HttpErrors, they are used to send additional information about the error, for example, validation error must return which fields weren't properly set.

## Linking @libstack/router on your express application

So, let's pretend we have created a router on `./routers/MyRouter.ts` and an interceptor on `./interceptors/MyInterceptor.ts`

```typescript
import express from 'express';
import controller from '@libstack/router';

// then you will need to import the routers and interceptors in order to be loaded
// just import the router and interceptors and they'll be attached to the `controller`
import './routers/MyRouter';
import './interceptors/MyInterceptor';

const app = express();

app.use(controller.router); // use plugin the @libstack/router to your express app
app.listen(process.env.PORT || 8080);
```

