import { ModelCtor, Sequelize } from 'sequelize-typescript';
import { config } from '@libstack/server';
import SequelizeMigration, { MigrationOptions } from './migration';
import './interceptors';

export interface SyncOptions {
  clear: boolean;
}

export class Database {
  sequelize:Sequelize;
  migration:SequelizeMigration;

  constructor() {
    const DB_NAME:string = config.get('DB_NAME');
    const DB_USERNAME:string = config.get('DB_USERNAME');
    const DB_PASSWORD:string = config.get('DB_PASSWORD');

    this.sequelize = new Sequelize(DB_NAME, DB_USERNAME, DB_PASSWORD, {
      host: config.get('DB_HOST'),
      port: config.getNumber('DB_PORT'),
      logging: config.getBoolean('VERBOSE') && console.log,

      dialect: config.innerConfig['DB_DIALECT'],

      dialectOptions: {
        socketPath: config.get('DB_SOCKET_PATH'),
        supportBigNumbers: true,
        bigNumberStrings: true,
        multipleStatements: config.getBoolean('SYNC')
      },

      define: {
        underscored: true,
        freezeTableName: false,
        charset: 'utf8',
        collate: 'utf8_general_ci',
        timestamps: true,

        updatedAt: 'updated_at',
        createdAt: 'created_at',
        deletedAt: 'removed_at',

        paranoid: false
      },

      sync: { force: false },

      pool: {
        max: config.getNumber('DB_POOL_MAX_CONNECTIONS', 50),
        min: config.getNumber('DB_POOL_MIN_CONNECTIONS', 0),
        idle: config.getNumber('DB_POOL_MAX_IDLE_TIME', 30)
      }
    });

    this.migration = new SequelizeMigration(this.sequelize);
  }

  loadMigrations(options:MigrationOptions) {
    this.migration.addModule(options);
  }

  sync = async (options?: SyncOptions) => {
    if (options && options.clear) {
      if (process.env.NODE_ENV !== 'test') {
        throw new Error('Clear is only allowed when NODE_ENV is `test`');
      }
      await this.sequelize.getQueryInterface().dropAllTables({ force: true });
    }
    await this.migration.sync();
  };
}

export const database = new Database();

export function SequelizeModel(target: Function): void;
export function SequelizeModel(arg: any): void | Function {
  if (typeof arg === 'function') {
    inject(arg);
  } else {
    return (target: any) => inject(target);
  }
}

function inject(target: ModelCtor): void {
  database.sequelize.addModels([target]);
}