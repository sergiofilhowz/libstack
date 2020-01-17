import AWS from 'aws-sdk';
import { Agent } from 'https';
import { DataApi, DataApiOptions } from './DataApi';
import { DataApiConnectionManager } from './DataApiConnectionManager';
import { DataApiQuery } from './DataApiQuery';

const sslAgent: Agent = new Agent({
  keepAlive: true,
  maxSockets: 50,
  rejectUnauthorized: true
});

function extendFunction(object: any, property: string, subfunction: Function): void {
  const func = object[property];
  object[property] = function () {
    const suuper = function () {
      return func.apply(object, arguments);
    };
    return subfunction(suuper, ...arguments);
  }
}

/**
 * Use this function to override the current sequelize implementation
 * to connect to Amazon Data API
 *
 * @param sequelize the sequelize instance
 * @param options the connection options
 */
export function enableDataAPI(sequelize: any, options: DataApiOptions): void {
  AWS.config.update({ httpOptions: { agent: sslAgent } });

  const dataAPI: DataApi = new DataApi(options);

  sequelize.connectionManager = new DataApiConnectionManager(dataAPI);
  sequelize.dialect.Query = DataApiQuery;

  sequelize.dialect.DataTypes.DATE.prototype._stringify = function (date: any, options: any) {
    return this._applyTimezone(date, options).format('YYYY-MM-DD HH:mm:ss');
  };

  if (sequelize.options.dialect === 'postgres') {
    sequelize.dialect.DataTypes.DATE.prototype.bindParam = function (value: any, options: any) {
      if (this._bindParam) {
        return this._bindParam(value, options) + '::date';
      }
      return options.bindParam(this.stringify(value, options), null) + '::date';
    };
  }

  extendFunction(sequelize, 'getQueryInterface', (suuper: () => any) => {
    const queryInterface: any = suuper();
    extendFunction(queryInterface, 'startTransaction', (suuper: any, transaction: any) => {
      return transaction.connection.beginTransaction().then((transactionId: string) => {
        transaction.id = transactionId;
      });
    });
    extendFunction(queryInterface, 'commitTransaction', (suuper: any, transaction: any) => {
      return transaction.connection.commitTransaction(transaction.id);
    });
    extendFunction(queryInterface, 'rollbackTransaction', (suuper: any, transaction: any) => {
      return transaction.connection.rollbackTransaction(transaction.id);
    });
    return queryInterface;
  });
}