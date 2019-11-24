import chai from 'chai';
import chaiHttp from 'chai-http';
import _ from 'lodash';
import { Server } from '@libstack/server';
import { Response, SuperAgentRequest } from 'superagent';

chai.use(chaiHttp);
chai.should();

/**
 * This is the options every request will use
 */
export interface RequestOptions {
  query?: any;
  headers?: any;
}

/**
 * This function will be used to decorate requests. Please take a look at RequestOptions,
 * Before the execution of every request, this function will be invoked to change the requests,
 * for example by creating a new `Authorization` Header param on your requests.
 */
export interface RequestDecorator {
  /**
   * Will be called to decorate the request on every request
   *
   * @param request
   */
  decorateRequest(request: RequestOptions): Promise<RequestOptions>
}

/**
 * This class represents HTTP access to your API
 */
export class Http {
  server: Server;
  requestDecorator: RequestDecorator;

  constructor(httpServer: Server, optionsDecorator?: RequestDecorator) {
    this.server = httpServer;
    this.requestDecorator = optionsDecorator;
  }

  private request(): ChaiHttp.Agent {
    return chai.request(this.server.server);
  }

  private async handleOptions(result: SuperAgentRequest, request: RequestOptions = {}) {
    if (!request.headers) request.headers = {};
    if (!request.query) request.query = {};

    const resultOptions: RequestOptions = await this.decorateRequest(request);
    if (resultOptions.headers) {
      _.forEach(resultOptions.headers, (value, key) => result.set(key, value));
    }
    if (resultOptions.query) {
      result.query(resultOptions.query);
    }
  }

  private async handleRequest(result: SuperAgentRequest, options: RequestOptions): Promise<Response> {
    await this.handleOptions(result, options);
    return new Promise(resolve => result.end((err, res) => resolve(res)));
  }

  /**
   * Performs a GET request
   *
   * @param path
   * @param options
   */
  get = (path: string, options?: RequestOptions): Promise<Response> => {
    return this.handleRequest(this.request().get(path), options);
  };

  /**
   * Performs a DELETE request
   *
   * @param path
   * @param options
   */
  delete = (path: string, options?: RequestOptions): Promise<Response> => {
    return this.handleRequest(this.request().delete(path), options);
  };

  /**
   * Performs a POST request
   *
   * @param path
   * @param body the payload to perform the request
   * @param options
   */
  post = (path: string, body?: any, options?: RequestOptions): Promise<Response> => {
    const result = this.request().post(path);
    if (body) {
      result.send(body);
    }
    return this.handleRequest(result, options);
  };

  /**
   * Performs a PUT request
   *
   * @param path
   * @param body the payload to perform the request
   * @param options
   */
  put = (path: string, body?: any, options?: RequestOptions): Promise<Response> => {
    const result = this.request().put(path);
    if (body) {
      result.send(body);
    }
    return this.handleRequest(result, options);
  };

  /**
   * Use it if you want to create modifications on all requests.
   * It will return another instance of Http with the RequestDecorator
   * that will be used to decorate all requests
   *
   * A good example to use it is to create an authenticated request
   *
   * @param decorator
   */
  as(decorator: RequestDecorator): Http {
    return new Http(this.server, decorator);
  }

  private decorateRequest(request: RequestOptions): Promise<RequestOptions> {
    return this.requestDecorator ? this.requestDecorator.decorateRequest(request) : Promise.resolve(request);
  }
}

/**
 * This class will help testing your API.
 * All you need to do is create an instance of TestHelper
 * by passing your Server to it.
 *
 * Then you can create requests `POST`, `PUT`, `GET` and `DELETE`.
 * You can decorate requests using the `as` function.
 */
export class TestHelper {
  http: Http;
  expect: Chai.ExpectStatic;

  constructor(server: Server) {
    this.http = new Http(server);
    this.expect = chai.expect;
  }
}