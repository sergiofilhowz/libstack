---
id: libstack
title: Understanding Libstack
sidebar_label: Understanding Libstack
---

## What is Libstack?

Libstack is a multi module project that aims to help building NodeJS servers with
the highest productivity and quality possible. And yet this is not a framework, you can use just the
modules you like.

## What modules do we currently have in Libstack?

Currently we have a few modules:
* Sequel module with Sequelize and migration.
* DataModel module to help returning your models with Custom model interfaces and filtering.
* Test module to test your application.
* Router module to help creating Express routes.
* Server module to build your NodeJS server.

## Architecture
First let's understand the architecture then we will jump in to the code.
There are 3 core components on the `libstack` architecture, which are: Config, Routers and the Server.

### Config
This component will help reading config data either from file or from Environment Variables. We usually have some properties that is tied to a specific environment: tests, dev, staging, production, etc.
So, you can create multiple files, one for each environment `NODE_ENV`. Take a look on the folder described bellow.

```
└── config/
    ├── default.json
    ├── test.json 
    ├── development.json 
    ├── staging.json 
    └── production.json 
```

We can see there's a `default.json` file, this one will have properties that are common to most environments, but all of those properties can be overriden either by file or by Environment Variable.
The rest or the files will be resolved based on the `proccess.env.NODE_ENV`. You can have as many environment as you want.

#### Using the config
To use the config variables, you don't need to explicity use `process.env`. Instead, there's a module to use.

```typescript
import { config } from '@libstack/server';

// for booleans "true" will be resolved to true and "false" will be resolved to false
const booleanVar: boolean = config.getBoolean('MY_BOOLEAN_ENV_VARIABLE'); 
const stringVar: string = config.get('MY_STRING_ENV_VARIABLE', 'my-optional-default-value');
const numberVar: number = config.getNumber('MY_NUMBER_ENV_VARIABLE', 1);
```

### Routers
Now we need to write the entrance point for our server. It's always good to take a look on the `@libstack/router` documentation.

The `@libstack/router` is part of the `@libstack/server` architecture but can be used standalone.

Take a look on the code bellow. As you can see, there's a decorator `@RestController` that will instantiate the router automatically, so you don't need to call or even assign it to the express instance.

```typescript
import { RestController, GET } from '@libstack/server';
import { Request } from 'express';

// This annotation will automatically create the proper express router
@RestController('/sample')
export default class SampleRouter {

  @GET('/')
  async getSample(req: Request): Promise<{ text: string }> {
    return { text: 'Sample Router' };
  }

}
```

But the file isn't resolved automatically, you need to explicitly import the router on your `server.js` file, in the next session you can see the code to it.

### Server

The server is the bootstrap, you can configure some startup scripts to be executed before the Server is booted.

```typescript
import { Server } from '@libstack/server';
import './routers/SampleRouter'; // just import the router and it will create the express routes

const server = new Server();

server.beforeStartup(async () => {
  // put your async process to run on startup
});

export default server;
```