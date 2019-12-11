import { HttpError } from '@libstack/router';

export class KeycloakError extends HttpError {
  constructor(message: string) {
    super(message, 500);
  }
}

export class UserCreationError extends KeycloakError {
  constructor(message: string) {
    super(message);
  }
}

export class GroupCreationError extends KeycloakError {
  constructor(message: string) {
    super(message);
  }
}