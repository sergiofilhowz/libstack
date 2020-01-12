# @libstack/sequel
Adds sequelize integration to your `@libstack/server`.

## Installing

```
npm install @libstack/sequel --save
```

## New env variables
>- `VERBOSE`: When true, SQL will be logged to console
>- `SYNC`: This variable indicates to execute the syncronization process
>- `DB_DIALECT`: Sequelize database dialect
>- `DB_HOST`: Sequelize database address
>- `DB_PORT`: Sequelize database port
>- `DB_NAME`: Sequelize database name
>- `DB_USERNAME`: Sequelize database user
>- `DB_PASSWORD`: Sequelize database password
>- `DB_POOL_MAX_CONNECTIONS`: Max connections on pool
>- `DB_POOL_MAX_IDLE_TIME`: Max idle time for connections on pool
>- `DB_MAX_CONCURRENT_QUERIES`: Max concurrent queries on sequelize

## Link Models to Sequelize
This module provides a way to automatically add your models to the main sequelize instance.

```typescript
import { IsUUID, Model, PrimaryKey, Table, Column, Length } from 'sequelize-typescript';
import { SequelizeModel } from '@libstack/sequel';

@SequelizeModel // just use this decorator and the model will be added to sequelize
@Table({ tableName: 'person' })
export class Person extends Model<Person> {

  @IsUUID("4")
  @PrimaryKey
  @Column
  id: string;

  @Length({ min: 3, max: 32 })
  @Column
  first_name: string;

  @Length({ min: 3, max: 32 })
  @Column
  last_name: string;

  @Column
  age: number;

}
```

## Migration
The migration is done through raw SQL files, which gives more control on what you are modifying on the database.
You will need to create a folder with the supported dialects as subfolders, for example:

```
└ db/
  ├ postgres/
  └ mysql/ 
```

Then, add the scripts with the given format name:

```
└ db/
  ├ postgres/
    └ V20191123130301__create.sql
```

Which means:

```
V{YYYY}{MM}{DD}{HH}{mm}{SS}__{script_name}.sql
```

Migration scripts will be executed on the chronological order.

Then you need to load the migrations on `@libstack/sequel`

```typescript
import { database } from '@libstack/sequel';
import { join } from 'path';

database.loadMigrations({ dir: join(__dirname, '..', 'db') });
```

And on `@libstack/server` you will need to configure a prestart script

```typescript
import { Server } from '@libstack/server';
import { database } from '@libstack/sequel';

const server: Server = new Server();
server.beforeStartup(database.sync);
```

### Separate statements
Some connectors may limit the execution as 1 statement per query call. Which means migration will need to separate statements on migration files.

To do that you will need to enable the statement separation

```typescript
database.loadMigrations({ 
  dir: join(__dirname, '..', 'db'),

  /**
   * IMPORTANT Note: The statement separation is based on the semicolon, which means
   * that creation of FUNCTION, TRIGGER or STORED PROCEDURE are NOT supported on this mode.
   */
  separateStatements: true 
});
```

> IMPORTANT Note: The statement separation is based on the semicolon, which means
     that creation of FUNCTION, TRIGGER or STORED PROCEDURE are NOT supported on this mode.

### Syncing manually
You can manually sync database, mostly used on tests

```typescript
import { database } from '@libstack/sequel';

describe('My Test Case', () => {
  /* the clear is a property that, when set to true, will erase the database then sync again
   * this is important to not have tests with side effects
   * but this flag can only be used if the NODE_ENV is `test`. */
  before(() => database.sync({ clear: true }));
});
```
