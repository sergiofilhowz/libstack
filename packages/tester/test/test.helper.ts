import { RequestDecorator, RequestOptions, TestHelper } from '@libstack/tester';
import server from './mock.server'; // import the server from your application

export const testHelper = new TestHelper(server);

class AuthenticationDecorator implements RequestDecorator {
  private token: string;

  /*
   * Let's store the authentication data on the class
 	 */
  constructor(private user: string, private pass: string) {}

  /*
   * Now let's create a business logic to perform login and return the JWT bearer
 	 */
  private async performLogin(): Promise<string> {
    // business logic to perform a login and return the JWT bearer token
    return `${this.user}-${this.pass}`;
  }

  /**
   * This function will be called on every request
   */
  async decorateRequest(request: RequestOptions): Promise<RequestOptions> {
    if (!this.token) {
      this.token = await this.performLogin();
    }
    request.headers.Authorization = 'Bearer ' + this.token;

    return request;
  }
}

export const admin: RequestDecorator = new AuthenticationDecorator('admin', '123456');
export const user: RequestDecorator = new AuthenticationDecorator('user', '123456');