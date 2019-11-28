---
id: getting-started
title: Getting Started
sidebar_label: Getting Started
---

## Installing

To start using Libstack we recommend pulling the example server (With SQL).

> The repository is located here: https://github.com/sergiofilhowz/libstack/tree/master/examples/sample-server

But let's understand what's inside and why.

## File structure

The file structure will look like this

```
├── config/
│   ├── default.json
│   ├── test.json 
│   ├── development.json 
│   └── production.json 
├── src/
│   ├── db/
│   │   └── postgres/
│   │       └── V20191128140100__create_schema.sql
│   └── node/
│       ├── models/
│       │   └── PersonModel.ts
│       ├── routers/
│       │   └── PersonRouter.ts
│       ├── sequelize/
│       │   └── Person.ts
│       ├── services/
│       │   └── PersonService.ts
│       ├── index.ts
│       └── server.ts
└── test/
    ├── TestHelper.ts 
    └── PersonRouter.test.ts
```

### Config Folder

Inside the config folder there are all files with predefined env variables for each environment.

> **NOTE:** Sensitive variables, like database password must not be on the files for production environments

### Src folder

Inside source we will put SQL files to be executed automatically and typescript files for the server, those files are all meant for production.

### Inside Source Folder

We have four folders inside node. One of each layer of the application.

* **Models**: Files inside will be the data models from `@libstack/data`.
* **Routers**: Files inside will be the routes from `@libstack/router`.
* **Sequelize**: Files inside will be sequelize models.
* **Service**: Files inside will contain the business logic of your application.

### Test folder

All tests from your application should be located here.

#### TestHelper.ts

Inside this file you should put the common business logic to test your application. Like authenticating before performing a request and so.
More details about it can be referred on @libstack/tester section.

## Starting the Application

The application is ready to be started. But first you need to either configure the `config/development.json` file or start the database with `docker-compose.yml` file located on the root folder

But first you will need to load your dependencies.

```
$ npm install
```

### Starting external services

To start external services from docker compose you need to have docker installed in your machine.

```
$ docker-compose up
```

### Starting the Application

After all external services are started, you can then start your application.

```
$ npm start
```

### Testing the Application

After all external services are started, you can also test your application. Remember the tests are integration tests and runs on a real database, which is recommended because you can be sure the modifications will work on production.

```
$ npm test
```