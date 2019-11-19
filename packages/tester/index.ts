import chai from 'chai';
import chaiHttp from 'chai-http';
import forEach from 'lodash/forEach';
import { Server } from '@libstack/server';
import { SuperAgentRequest, Response } from 'superagent';

chai.use(chaiHttp);
chai.should();

export type OptionsDecorator = (options:RequestOptions) => Promise<RequestOptions>;

export interface RequestOptions {
  body?:any;
  query?:any;
  headers?:any;
}

export class Http {
  server:Server;
  optionsDecorator:OptionsDecorator;

  constructor(httpServer:Server, optionsDecorator?:OptionsDecorator) {
    this.server = httpServer;
    this.optionsDecorator = optionsDecorator;
  }

  private request():ChaiHttp.Agent {
    return chai.request(this.server.server);
  }

  private async handleOptions(result:SuperAgentRequest, options:RequestOptions = {}) {
    const resultOptions = await this.decorateOptions(options);
    if (resultOptions.headers) {
      forEach(resultOptions.headers, (value, key) => result.set(key, value));
    }
    if (resultOptions.query) {
      result.query(resultOptions.query);
    }
  }

  private async handleRequest(result:SuperAgentRequest, options:RequestOptions):Promise<Response> {
    await this.handleOptions(result, options);
    return new Promise(resolve => result.end((err, res) => resolve(res)));
  }

  get = (path:string, options?:RequestOptions):Promise<Response> => {
    return this.handleRequest(this.request().get(path), options);
  };

  delete = (path:string, options?:RequestOptions):Promise<Response> => {
    return this.handleRequest(this.request().delete(path), options);
  };

  post = (path:string, body:any, options?:RequestOptions):Promise<Response> => {
    const result = this.request().post(path);
    if (body) {
      result.send(body);
    }
    return this.handleRequest(result, options);
  };

  put = (path:string, body:any, options?:RequestOptions):Promise<Response> => {
    const result = this.request().put(path);
    if (body) {
      result.send(body);
    }
    return this.handleRequest(result, options);
  };

  as(decorator:OptionsDecorator) {
    return new Http(this.server, decorator);
  }

  decorateOptions(options:RequestOptions):Promise<RequestOptions> {
    return this.optionsDecorator ? this.optionsDecorator(options) : Promise.resolve(options);
  }
}

export class TestHelper {
  http:Http;
  expect:Chai.ExpectStatic;

  constructor(server:Server) {
    this.http = new Http(server);
    this.expect = chai.expect;
  }
}