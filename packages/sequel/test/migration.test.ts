import { database } from '../lib/database';
import { Table_1_0_0 } from './models/Table_1_0_0';
import { Table_1_0_1 } from './models/Table_1_0_1';
import { Table_1_1_0 } from './models/Table_1_1_0';
import { Table_1_1_1 } from './models/Table_1_1_1';
import { join } from 'path';
import { expect } from 'chai';
import { unlinkSync, writeFileSync } from 'fs';

const { sequelize, migration } = database;
const { Migration } = migration;

database.loadMigrations({
  dir: join(__dirname, 'module'),
  separateStatements: true
});

describe('Sequelize Migration', () => {

  beforeEach(() => {
    return Promise.all([
      sequelize.query('DROP TABLE IF EXISTS table_1_0_0'),
      sequelize.query('DROP TABLE IF EXISTS table_1_0_1'),
      sequelize.query('DROP TABLE IF EXISTS table_1_1_0'),
      sequelize.query('DROP TABLE IF EXISTS table_1_1_1'),
      sequelize.query('DROP TABLE IF EXISTS table_2_0_0'),
      sequelize.query('DROP TABLE IF EXISTS table_2_0_1'),
      sequelize.query('DROP TABLE IF EXISTS db_migration')
    ]);
  });

  it('should create schema', async () => {
    await database.sync();
    await Table_1_0_0.findAll();
    await Table_1_0_1.findAll();
    await Table_1_1_0.findAll();

    const migrations = await database.migration.Migration.findAll({
      order: [['script_name', 'ASC']]
    });

    expect(migrations).with.length(4);

    expect(migrations[0].execution_ts).to.not.be.undefined;
    expect(migrations[0].script_name).equal('V20161126203834__create_table_1_0_0.sql');
    expect(migrations[0].description).equal('create table 1 0 0');
    expect(migrations[0].version).equal('20161126203834');
    expect(migrations[0].success).equal(true);

    expect(migrations[1].execution_ts).to.not.be.undefined;
    expect(migrations[1].script_name).equal('V20161126204011__create_table_1_0_1.sql');
    expect(migrations[1].description).equal('create table 1 0 1');
    expect(migrations[1].version).equal('20161126204011');
    expect(migrations[1].success).equal(true);

    expect(migrations[2].execution_ts).to.not.be.undefined;
    expect(migrations[2].script_name).equal('V20161126204548__create_table_1_1_0.sql');
    expect(migrations[2].description).equal('create table 1 1 0');
    expect(migrations[2].version).equal('20161126204548');
    expect(migrations[2].success).equal(true);

    expect(migrations[3].execution_ts).to.not.be.undefined;
    expect(migrations[3].script_name).equal('V20200112083706__create_tables.sql');
    expect(migrations[3].description).equal('create tables');
    expect(migrations[3].version).equal('20200112083706');
    expect(migrations[3].success).equal(true);
  });

  it('should update schema', async () => {
    const newScriptPathMysql = join(__dirname, 'module', 'mysql', 'V20161126204548__create_table_1_1_1.sql');
    const newScriptPathPostgres = join(__dirname, 'module', 'postgres', 'V20161126204548__create_table_1_1_1.sql');

    await database.sync();
    await Table_1_0_0.findAll();
    await Table_1_0_1.findAll();
    await Table_1_1_0.findAll();

    expect(async () => Table_1_1_1.findAll()).to.throws;

    const migrations = await Migration.findAll({
      order: [['script_name', 'ASC']]
    });

    expect(migrations).with.length(4);

    writeFileSync(newScriptPathMysql, `
      CREATE TABLE table_1_1_1 (
        id bigint(20) NOT NULL AUTO_INCREMENT,
        name varchar(255) NOT NULL,
        PRIMARY KEY (id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
    `);

    writeFileSync(newScriptPathPostgres, `
      CREATE TABLE table_1_1_1 (
        id BIGINT PRIMARY KEY NOT NULL,
        name VARCHAR(255) NOT NULL
      );
    `);

    await migration.sync();
    await Table_1_1_1.findAll();

    unlinkSync(newScriptPathMysql);
    unlinkSync(newScriptPathPostgres);
  });

});