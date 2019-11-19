import express, { Application } from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import { createServer, Server as HttpServer } from 'http';
import config from './config';
import controller from '@libstack/router';

export class Server {
  app:Application;
  server:HttpServer;

  private beforeScripts:Array<Function> = [];

  constructor() {
    this.app = express();
    this.server = createServer(this.app);

    this.app.use(cors({ allowedHeaders: ['Content-Type', 'Authorization'] }));
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

export default Server;
