import { ModelCtor, Sequelize } from 'sequelize-typescript';
import { config } from '@libstack/server';
import SequelizeMigration, { MigrationOptions } from './migration';
import './interceptors';
import { Dialect } from 'sequelize';

export interface SyncOptions {
  clear: boolean;
}

export interface DatabaseOptions {
  database: string;

  username: string;
  password: string;

  host?: string;
  port?: number;

  logging?: boolean;
  dialect: Dialect;

  sync?: boolean;

  socketPath?: string;

  poolMax?: number;
  poolMin?: number;
  poolIdle?: number;
}

export class Database {
  sequelize: Sequelize;
  migration: SequelizeMigration;

  constructor(options: DatabaseOptions) {
    this.sequelize = new Sequelize(options.database, options.username, options.password, {
      host: options?.host,
      port: options?.port,
      logging: options?.logging && console.log,

      dialect: options?.dialect,

      dialectOptions: {
        socketPath: options.socketPath,
        supportBigNumbers: true,
        bigNumberStrings: true,
        multipleStatements: options.sync
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
        max: options.poolMax,
        min: options.poolMin,
        idle: options.poolIdle
      }
    });

    this.migration = new SequelizeMigration(this.sequelize);
  }

  /**
   * Use this to add migrations to a Database
   * @param options
   */
  loadMigrations(options: MigrationOptions) {
    this.migration.addModule(options);
  }

  sync = async (options?: SyncOptions) => {
    if (options && options.clear) {
      if (process.env.NODE_ENV !== 'test') {
        throw new Error('Clear is only allowed when NODE_ENV is `test`');
      }
      await this.sequelize.getQueryInterface().dropAllTables({ force: true });
      await this.sequelize.getQueryInterface().dropAllEnums();
    }
    await this.migration.sync();
  };
}

export const database = new Database({
  database: config.get('DB_NAME'),

  username: config.get('DB_USERNAME'),
  password: config.get('DB_PASSWORD'),

  dialect: config.innerConfig['DB_DIALECT'],

  host: config.get('DB_HOST'),
  port: config.getNumber('DB_PORT'),
  
  logging: config.getBoolean('VERBOSE'),

  socketPath: config.get('DB_SOCKET_PATH'),

  poolMax: config.getNumber('DB_POOL_MAX_CONNECTIONS', 50),
  poolMin: config.getNumber('DB_POOL_MIN_CONNECTIONS', 0),
  poolIdle: config.getNumber('DB_POOL_MAX_IDLE_TIME', 30),
});

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