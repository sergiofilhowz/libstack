import { HttpError } from './http.error';
import express, { Request, Response, Router } from 'express';
import InterceptorManager, { Interceptor } from './interceptor';

class Controller {
  router:Router;
  interceptorManager:InterceptorManager;

  constructor() {
    this.router = express.Router();
    this.interceptorManager = new InterceptorManager();
  }

  createInterceptor(interceptor:Interceptor) {
    this.interceptorManager.add(interceptor);
  }

  route(path:string):ControllerRoute {
    const route = new ControllerRoute(this.interceptorManager, path);
    this.router.use(route.path, route.router);
    return route;
  }
}

export const controller = new Controller();

export function RestInterceptor() {
  return function(interceptor:any) {
    controller.createInterceptor(new interceptor());
  }
}

export function RestController(path:string) {
  return function(clazz:any) {
    const config = clazz.prototype.httpConfig || [];

    clazz.route = controller.route(path);
    config.forEach((params:RouteParams) => clazz.route.add(params));
  }
}

function decorator(method:string, clazz:any, callback:Function, path:string, options?:any) {
  clazz.httpConfig = clazz.httpConfig || [];
  clazz.httpConfig.push({ method, path, callback, options });
}

export function GET(path:string, options?:any) {
  return function (clazz:any, _:any, descriptor:PropertyDescriptor) {
    return decorator('get', clazz, descriptor.value, path, options);
  }
}

export function POST(path:string, options?:any) {
  return function (clazz:any, _:any, descriptor:PropertyDescriptor) {
    return decorator('post', clazz, descriptor.value, path, options);
  }
}

export function PUT(path:string, options?:any) {
  return function (clazz:any, _:any, descriptor:PropertyDescriptor) {
    return decorator('put', clazz, descriptor.value, path, options);
  }
}

export function DELETE(path:string, options?:any) {
  return function (clazz:any, _:any, descriptor:PropertyDescriptor) {
    return decorator('delete', clazz, descriptor.value, path, options);
  }
}

export class ControllerRoute {
  path:string;
  router:Router;
  map:any;
  interceptorManager:InterceptorManager;

  constructor(interceptorManager:InterceptorManager, path:string) {
    this.router = express.Router();
    this.interceptorManager = interceptorManager;
    this.path = path;
    this.map = {
      post: this.router.post.bind(this.router),
      put: this.router.put.bind(this.router),
      get: this.router.get.bind(this.router),
      delete: this.router.delete.bind(this.router),
      patch: this.router.patch.bind(this.router)
    };
  }

  add(parameters:RouteParams) {
    const fn:Function = this.map[parameters.method || 'get'];
    const params:RouteParams = {
      path: this.path + parameters.path,
      method: parameters.method,
      options: parameters.options
    };
    params.path = params.path.replace('//', '/');
    fn(parameters.path, async (req:Request, res:Response) => {
      const end:Function = res.end;
      res.end = function() {
        res.locals.ended = true;
        return end.apply(res, arguments);
      };

      try {
        const result = await this.interceptorManager.intercept(params, req, res, parameters.callback);
        this.handle(res, null, result);
      } catch (err) {
        this.handle(res, err);
      }
    });
  }

  handle(res:Response, err:Error, result?:any) {
    if (err) {
      if (err instanceof HttpError) {
        res.status(err.code).json({
          message: err.message,
          data: err.data
        });
      } else {
        console.error(err);
        res.status(500).json({
          message: 'Internal server error',
          data: {}
        });
      }
    } else if (!res.locals.ended) {
      res.json(result);
    }
  }
}

export interface RouteParams {
  path:string;
  method:string;
  options?:any;
  callback?:Function;
}

export default controller;