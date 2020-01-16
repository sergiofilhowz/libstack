import _ from 'lodash';
import { QueryTypes, Sequelize } from 'sequelize';
// @ts-ignore
import { AbstractQuery } from 'sequelize/lib/dialects/abstract/query';
import { CommonResult, DataApi, DataApiConnection } from './DataApi';

export class DataApiConnectionManager {
  constructor(private readonly dataApi: DataApi) {}

  refreshTypeParser(DataTypes: any) {}

  getConnection(options: any): DataApiConnection {
    return new DataApiConnection(this.dataApi);
  }

  releaseConnection(): void {}

  close() {}
}

export class DataApiQuery extends AbstractQuery {
  constructor(private readonly connection: DataApiConnection,
              private readonly sequelize: Sequelize,
              private readonly options: any) {
    super(connection, sequelize, options);
  }

  static formatBindParameters(sql: string, parameters: any []) {
    return [sql, parameters];
  }

  run(sql: string, parameters: any []): any {
    console.log(sql, parameters);
    return this.connection.query(sql, parameters).then((result: CommonResult) => {
      // @ts-ignore
      if (this.isInsertQuery(sql) || this.isUpdateQuery(sql)) {
        if (this.options.instance && this.options.instance.dataValues) {
          for (const key in result.rows[0]) {
            if (Object.prototype.hasOwnProperty.call(result.rows[0], key)) {
              const record = result.rows[0][key];

              const attr = _.find(this.options.model.rawAttributes,
                  attribute => attribute.fieldName === key || attribute.field === key);

              this.options.instance.dataValues[attr && attr.fieldName || key] = record;
            }
          }
        }

        return [
          this.options.instance || result.rows && (this.options.plain && result.rows[0]) || undefined,
          result.affectedRows
        ];
      }

      // @ts-ignore
      if (this.isSelectQuery()) {
        // @ts-ignore
        return this.handleSelectQuery(result.rows);
      }

      return result.rows;
    });
  }

  isInsertQuery(sql: string): boolean {
    return sql.toLowerCase().startsWith('insert into');
  }
}