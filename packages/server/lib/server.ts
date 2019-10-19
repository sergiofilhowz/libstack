import express, { Application } from 'express';
import bodyParser from 'body-parser';
import { createServer, Server } from 'http';
import config from './config';
import controller from 'express-power-router';
import './interceptors';

export class NodeServer {
  app:Application;
  server:Server;

  private beforeScripts:Array<Function> = [];

  constructor() {
    this.app = express();
    this.server = createServer(this.app);

    this.app.use(bodyParser.json({ limit: '20mb' }));
    this.app.use('/', controller.router);
  }

  beforeStartup(fn:Function) {
    this.beforeScripts.push(fn);
  }

  async start() {
    for (const fn of this.beforeScripts) {
      await fn();
    }
    const port:number = config.getNumber('PORT') || 8080;
    this.server.listen(port, () => console.log(`Server started at port ${port}`));
  };
}

export default NodeServer;
