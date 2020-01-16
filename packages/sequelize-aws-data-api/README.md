# AWS Data API connector for Sequelize
Adds integration between Sequelize and Aurora Serverless Data API

## Install
You will need Sequelize

```
$ yarn add sequelize
$ yarn add @libstack/sequelize-aws-data-api
```

## Usage

```typescript
import { enableDataAPI } from '@libstack/sequelize-aws-data-api';

const sequelize = new Sequelize(); // your sequelize instance
const resourceArn: string = 'arn:aws:rds:us-east-1:1894848215:cluster:cluster-name';
const secretArn: string = 'arn:aws:secretsmanager:us-east-1:1894848215:secret:staging/rds-db-credentials/cluster-name-As$jOI';
const database: string = 'database_name'; // must be the same from Sequelize's 
const region: string = 'us-east-1';
const verbose: boolean = false; // true to log all queries and other data. Default if false

enableDataAPI(sequelize, { resourceArn, secretArn, database, region, verbose });
```

## Supported Sequelize Versions
Currently only tested on Sequelize@5.21.3

### Aurora Serveless MySQL
Works pretty much with everything. Probably need to check the `SHOW TABLES` query.

### Aurora Serverless PostgreSQL
Works with INSERT, SELECT and most of the stuff, but it still in progress the native sequelize migration