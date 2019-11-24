# @libstack/tester
This module will help you test your `@libstack/server` API.

## Installation

```
npm install @libstack/tester --save-dev
```

## Usage

You will need to create a file on your test folder.

```typescript
import { TestHelper } from '@libstack/tester';
import server from '../src/node'; // import the server from your application

export default new TestHelper(server);
```

Then you can start performing requests on your application on unit tests.

```typescript
import TestHelper from './TestHelper';

const { http, expect } = TestHelper;

describe('Sample Router', () => {
  it('should return 200 on GET', async () => {
    const response = await http.get('/sample-router');
    expect(response.status).to.be.equal(200);
  });
  
  it('should return 200 on GET with queries', async () => {
    const query = { name: 'sergio' };
    // this request will be /sample-router?name=sergio
    const response = await http.get('/sample-router', { query });
    expect(response.status).to.be.equal(200);
  });
  
  it('should return 200 on POST', async () => {
    const body = { anything: '' };
    const response = await http.post('/sample-router', body);
    expect(response.status).to.be.equal(200);
  });
  
  it('should return 200 on PUT', async () => {
    const body = { anything: '' };
    const response = await http.put('/sample-router', body);
    expect(response.status).to.be.equal(200);
  });
  
  it('should return 200 on DELETE', async () => {
    const response = await http.delete('/sample-router');
    expect(response.status).to.be.equal(200);
  });
});
```

## Using decorators

When we are testing APIs, it's common to create some behaviors on requests, like an authenticated user. There's a method on `TestHelper.http` that enables this.

So, let's suppose we are trying to create an authenticated request. The user needs to login on the application, pick the JWT bearer token, then use it on all upcoming requests.

```typescript
import { RequestDecorator, RequestOptions, TestHelper } from '@libstack/tester';
import server from '../src/node'; // import the server from your application

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
    return 'c2VyZ2lvZmlsaG93QGdtYWlsLmNvbQ==';
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

export const testHelper = new TestHelper(server);
export const admin: RequestDecorator = new AuthenticationDecorator('admin', '123456');
export const user: RequestDecorator = new AuthenticationDecorator('user', '123456');
```

Then, on the tests, all you will need to do is

```typescript
import { Http } from '@libstack/tester';
import { testHelper, admin, user } from './TestHelper';

const http: Http = testHelper.http; // this HTTP will perform annonymous request
const httpAdmin: Http = http.as(admin); // this HTTP will perform admin authenticated requests
const httpUser: Http = http.as(user); // this HTTP will perform user authenticated requests
```

