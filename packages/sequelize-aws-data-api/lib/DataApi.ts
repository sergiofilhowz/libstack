import { RDSDataService } from 'aws-sdk';
import { Promise } from 'bluebird';
import {
  ColumnMetadata,
  CommitTransactionRequest,
  ExecuteStatementRequest,
  ExecuteStatementResponse,
  Field,
  Metadata,
  RollbackTransactionRequest,
  Value
} from 'aws-sdk/clients/rdsdataservice';
import _ from 'lodash';
import moment from 'moment';

declare type RecordParser = (record: any) => any;
declare type Parser = (column: Field) => string|number|boolean|null|number[]|string[];
declare type RowParser = (object: any, column: Field) => void;

const includeResultMetadata = true;

export interface CommonResult {
  resultId?: string | number;
  affectedRows?: number;
  rows?: any [];
}

/*
 * https://docs.aws.amazon.com/pt_br/AmazonRDS/latest/AuroraUserGuide/data-api.html
 */
const parserDictionary: { [key: string]: Parser } = {
  // MySQL
  BIT: column => column.isNull ? null : column.booleanValue,
  BOOLEAN: column => column.isNull ? null : column.booleanValue,

  VARCHAR: column => column.isNull ? null : column.stringValue,
  DATETIME: column => column.isNull ? null : moment.utc(column.stringValue).toDate().toISOString(),
  TEXT: column => column.isNull ? null : column.stringValue,

  BIGINT: column => column.isNull ? null : column.longValue,
  INT: column => column.isNull ? null : column.longValue,
  TINYINT: column => column.isNull ? null : column.longValue,
  SMALLINT: column => column.isNull ? null : column.longValue,
  INTEGER: column => column.isNull ? null : column.longValue,
  DECIMAL: column => column.isNull ? null : column.longValue ?? column.doubleValue,

  FLOAT: column => column.isNull ? null : column.doubleValue,
  REAL: column => column.isNull ? null : column.doubleValue,
  DOUBLE: column => column.isNull ? null : column.doubleValue,

  // PostgreSQL
  varchar: column => column.isNull ? null : column.stringValue,
  name: column => column.isNull ? null : column.stringValue,
  text: column => column.isNull ? null : column.stringValue,
  bool: column => column.isNull ? null : column.booleanValue,
  _int2: column => column.isNull ? null : column.arrayValue.longValues,
  int4: column => column.isNull ? null : column.longValue,
  _name: column => column.isNull ? null : `{${column.arrayValue.stringValues.join(',')}}`,
  int2vector: column => column.isNull ? null : column.stringValue,
  bigserial: column => column.isNull ? null : column.longValue,
  float8: column => column.isNull ? null : column.doubleValue,
  numeric: column => column.isNull ? null : column.stringValue,
  timestamptz: column => column.isNull ? null : moment(column.stringValue, 'YYYY-MM-DD HH:mm:ss').toDate().toISOString(),
};
const defaultParser = (column: Value) => column.isNull ? null : column.stringValue;

function getParser(type: string, column: Value): Parser {
  if (!parserDictionary[type]) {
    console.log(`WARN: ${type} not implemented `, column);
  }
  return parserDictionary[type] ?? defaultParser;
}

function createParsers(columnMetadata: Metadata): RowParser [] {
  const parsers: RowParser[] = [];
  _.forEach(columnMetadata, (metadata: ColumnMetadata) => {
    parsers.push((object: any, column: Field) => {
      object[metadata.label] = getParser(metadata.typeName, column)(column);
    });
  });
  return parsers;
}

function createParser(columnMetadata: Metadata): (record: any) => RecordParser {
  const parsers: RowParser [] = createParsers(columnMetadata);
  return (record: any): any => {
    const object = {};
    _.forEach(record, (field: Field, index: number) => parsers[index](object, field));
    return object;
  }
}

const parseResult = (data: ExecuteStatementResponse): CommonResult => {
  const { columnMetadata, numberOfRecordsUpdated, records, generatedFields } = data;
  const resultId: number = generatedFields && generatedFields.length ? generatedFields[0].longValue : undefined;

  if (!columnMetadata || !records) {
    return { resultId, affectedRows: numberOfRecordsUpdated, rows: [] };
  }

  const parser: RecordParser = createParser(columnMetadata);
  return { resultId, affectedRows: numberOfRecordsUpdated, rows: records.map(parser) };
};

const paramNames: string [] = [
  'first', 'second', 'third', 'forth', 'fifth', 'sixth', 'seventh',
  'eighth', 'nineth', 'tenth', 'eleventh', 'twelveth', 'thirteenth',
  'fourteenth', 'fifteenth', 'sixteenth', 'eleventeenth', 'eighteenth',
  'nineteenth', 'twentyth'
];

function getValueFromParam(param: any): Field {
  if (param === null || param === undefined) {
    return { isNull: true }
  }
  const type: string = typeof param;
  switch (type) {
    case 'boolean': return { isNull: false, booleanValue: param };
    case 'number':
      return (Math.floor(param) !== param)
        ? { isNull: false, doubleValue: param }
      : { isNull: false, longValue: param };
    case 'string': return { isNull: false, stringValue: param };
    default: throw new Error('Type not supported');
  }
}

function applyParams(sql: string, params: any []): { sql: string, parameters: any [] } {
  if (!params) return { sql, parameters: [] };

  const parameters: any [] = [];
  const newSql: string = sql.replace(/\$(\d+)/g, function (full, value) {
    const index = parseInt(value) - 1; // converting 1 based index to 0 based
    const paramName: string = paramNames[index];
    parameters.push({
      name: paramName,
      value: getValueFromParam(params[index])
    });
    return `:${paramName}`;
  });

  return { sql: newSql, parameters };
}

export interface DataApiOptions {
  resourceArn: string;
  secretArn: string;
  database: string;
  region: string;

  /**
   * Set to true if you want to log all queries
   */
  verbose?: boolean;
}

export class DataApi {
  private readonly resourceArn: string;
  private readonly secretArn: string;
  private readonly database: string;
  private readonly rdsdataservice: RDSDataService;

  readonly verbose?: boolean;

  constructor(options: DataApiOptions) {
    this.resourceArn = options.resourceArn;
    this.secretArn = options.secretArn;
    this.database = options.database;
    this.rdsdataservice = new RDSDataService({ region: options.region });
    this.verbose = options.verbose;
  }

  executeQuery(rawSql: string, sqlParams: any, transactionId: string): Promise<CommonResult> {
    const { sql, parameters } = applyParams(rawSql, sqlParams);
    const { resourceArn, secretArn, database } = this;
    const params: ExecuteStatementRequest = {
      secretArn, resourceArn, sql, parameters, database, includeResultMetadata, transactionId
    };
    return new Promise((resolve, reject) => {
      this.rdsdataservice.executeStatement(params, (err, data) => {
        if (err) reject(err);
        else     resolve(parseResult(data));
      });
    });
  };

  beginTransaction(): Promise<any> {
    const { resourceArn, secretArn, database } = this;
    const params = { secretArn, resourceArn, database };
    return new Promise((resolve, reject) => {
      this.rdsdataservice.beginTransaction(params, (err, data) => {
        if (err) reject(err);
        else     resolve(data);
      });
    });
  };

  commitTransaction(transactionId: string): Promise<any> {
    const { resourceArn, secretArn } = this;
    const params: CommitTransactionRequest = { secretArn, resourceArn, transactionId };
    return new Promise((resolve, reject) => {
      this.rdsdataservice.commitTransaction(params, (err, data) => {
        if (err) reject(err);
        else     resolve(data);
      });
    });
  };

  rollbackTransaction(transactionId: string): Promise<any> {
    const { resourceArn, secretArn } = this;
    const params: RollbackTransactionRequest = { secretArn, resourceArn, transactionId };
    return new Promise((resolve, reject) => {
      this.rdsdataservice.rollbackTransaction(params, (err, data) => {
        if (err) reject(err);
        else     resolve(data);
      });
    });
  };
}

let id = 0;

export class DataApiConnection {
  readonly id: number;
  readonly dataAPI: DataApi;
  readonly log?: (object: any) => void;

  transactionId?: string;

  constructor(dataAPI: DataApi) {
    this.dataAPI = dataAPI;
    this.id = id++;
    this.log = log => dataAPI.verbose && console.log(log);
  }

  end(fn: Function): void {
    delete this.transactionId;
    fn();
  }

  query(sql: string, parameters: any[]): any {
    return this.dataAPI.executeQuery(sql, parameters, this.transactionId);
  };

  beginTransaction(): Promise<string> {
    this.log(`[${this.id}] START TRANSACTION;`);
    return this.dataAPI.beginTransaction().then(({ transactionId }: any) => {
      this.transactionId = transactionId;
      return transactionId;
    });
  }

  commitTransaction(transactionId: string): Promise<void> {
    this.log(`[${this.id}] COMMIT;`);
    return this.dataAPI.commitTransaction(transactionId).then(() => {
      delete this.transactionId;
    });
  }

  rollbackTransaction(transactionId: string): Promise<void> {
    this.log(`[${this.id}] ROLLBACK;`);
    return this.dataAPI.rollbackTransaction(transactionId).then(() => {
      delete this.transactionId;
    });
  }
}