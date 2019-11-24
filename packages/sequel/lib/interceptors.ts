import { BadRequestError, CallableStack, Interceptor, RestInterceptor } from '@libstack/server';
import { ValidationError } from 'sequelize';
import { Request, Response } from 'express';

@RestInterceptor
class ValidationInterceptor implements Interceptor {
  intercepts(parameters: any, request: Request): boolean {
    return true;
  }

  async execute(parameters: any, req: Request, res: Response, stack: CallableStack): Promise<any> {
    try {
      return await stack.next();
    } catch (err) {
      if (err instanceof ValidationError) {
        const errors: any = {};
        for (let error of err.errors) {
          let field = errors[error.path];
          if (!field) {
            field = [];
            errors[error.path] = field;
          }
          field.push(error.message);
        }
        throw new BadRequestError('Validation Problems', { errors });
      }
      throw err;
    }
  }
}
