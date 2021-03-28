import _ from 'lodash';
import { QueryTypes, Sequelize } from 'sequelize';
import { CommonResult, DataApiConnection } from './DataApi';
// @ts-ignore
import { AbstractQuery } from 'sequelize/lib/dialects/abstract/query';

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
    this.connection.log(sql, parameters);
    return this.connection.query(sql, parameters).then((result: CommonResult) => {
      // @ts-ignore
      if (this.isInsertQuery(sql) || this.isUpdateQuery(sql)) {
        if (this.options.dialect === 'mysql') {
          const autoIncrementAttribute = this.options.model.autoIncrementAttribute;
          this.options.instance[autoIncrementAttribute] = result.resultId;
        } else if (this.options.instance && this.options.instance.dataValues) {
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

      if (this.options.type === 'FOREIGNKEYS') {
        return result.rows.map((row: any) => {
          let defParts;
          if (row.condef !== undefined && (defParts = row.condef.match(/FOREIGN KEY \((.+)\) REFERENCES (.+)\((.+)\)( ON (UPDATE|DELETE) (CASCADE|RESTRICT))?( ON (UPDATE|DELETE) (CASCADE|RESTRICT))?/))) {
            row.id = row.constraint_name;
            row.table = defParts[2];
            row.from = defParts[1];
            row.to = defParts[3];
            let i;
            for (i = 5; i <= 8; i += 3) {
              if (/(UPDATE|DELETE)/.test(defParts[i])) {
                row[`on_${defParts[i].toLowerCase()}`] = defParts[i + 1];
              }
            }
          }
          return row;
        });
      }

      const isTableNameQuery = sql.startsWith('SELECT table_name FROM information_schema.tables');
      const isRelNameQuery = sql.startsWith('SELECT relname FROM pg_class WHERE oid IN');

      if (isRelNameQuery) {
        return result.rows.map(row => ({
          name: row.relname,
          tableName: row.relname.split('_')[0]
        }));
      }
      if (this.options.type === 'SHOWTABLES') {
        return result.rows.map(row => _.values(row));
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
    if (this.options.type === QueryTypes.INSERT) {
      return true;
    }
    return sql.toLowerCase().startsWith('insert into');
  }

  isForeignKeysQuery(sql: string) {
    return /SELECT conname as constraint_name, pg_catalog\.pg_get_constraintdef\(r\.oid, true\) as condef FROM pg_catalog\.pg_constraint r WHERE r\.conrelid = \(SELECT oid FROM pg_class WHERE relname = '.*' LIMIT 1\) AND r\.contype = 'f' ORDER BY 1;/.test(sql);
  }
}
