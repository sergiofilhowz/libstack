import { HttpError } from 'express-power-router';

export class UnauthorizedError extends HttpError {
  constructor(message:string, data?:any) {
    super(message, 401, data);
  }
}