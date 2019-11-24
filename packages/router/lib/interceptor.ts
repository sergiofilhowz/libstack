import { Request, Response } from 'express';
import { RouteParams } from './controller';

/**
 * This service handles interceptors, to configure and to use inside Controller
 */
export default class InterceptorManager {
  interceptors: Array<Interceptor> = [];

  /**
   * Adds a new interceptor
   *
   * @param interceptor the interceptor
   */
  add(interceptor: Interceptor) {
    this.interceptors.unshift(interceptor);
  }

  intercept(parameters: RouteParams, req: Request, res: Response, callback:Function) {
    const options = parameters.options || {};
    let stack: CallableStack = {
      async next() {
        return callback(req, res);
      }
    };

    this.interceptors.forEach(interceptor => {
      if (interceptor.intercepts(options, req)) {
        const oldStack: CallableStack = stack;
        stack = {
          async next() {
            return interceptor.execute(options, req, res, oldStack);
          }
        };
      }
    });

    return stack.next();
  }
}

export interface Interceptor {
  /**
   * Will check the configured interceptors if they will execute and then stack
   * these interceptors to invoke them on a queue
   *
   * @param parameters the parameters configured on Controller
   * @param request the express request object
   */
  intercepts(parameters: any, request: Request): boolean;

  /**
   * Callback to execute the interceptor
   *
   * @param parameters parameters from controller
   * @param req the request being made
   * @param res the response
   * @param stack callable stack to continue the chain
   */
  execute(parameters: any, req: Request, res: Response, stack: CallableStack): Promise<any>;
}

/**
 * This is the interceptor execution stack. All interceptors
 * are linked withing the Callable Stack and in order to continue
 * the execution you need to call next(). If you don't call next() it will
 * halt the request stack.
 */
export interface CallableStack {
  /**
   * Calls the next execution, the last one will be the request itself.
   */
  next(): Promise<any>;
}