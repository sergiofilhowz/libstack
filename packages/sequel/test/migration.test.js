const path = require('path');
const chai = require('chai');
const fs = require('fs');
const SequelizeMigration = require('../dist/lib/migration');
const sequelize = require('./db.mock');
const expect = chai.expect;
const Table_1_0_0 = sequelize.import(path.join(__dirname, 'models', 'table.1.0.0'));
const Table_1_0_1 = sequelize.import(path.join(__dirname, 'models', 'table.1.0.1'));
const Table_1_1_0 = sequelize.import(path.join(__dirname, 'models', 'table.1.1.0'));
const Table_1_1_1 = sequelize.import(path.join(__dirname, 'models', 'table.1.1.1'));

let migration;
let Migration;

describe('Sequelize Migration', () => {

  beforeEach(() => {
    migration = new SequelizeMigration(sequelize);
    Migration = migration.Migration;

    return Promise.all([
      sequelize.query('drop table if exists table_1_0_0'),
      sequelize.query('drop table if exists table_1_0_1'),
      sequelize.query('drop table if exists table_1_1_0'),
      sequelize.query('drop table if exists table_1_1_1'),
      sequelize.query('drop table if exists db_migration')
    ]);
  });

  it('should create schema', () => {
    migration.addModule({
      name: 'my-name',
      dir: path.join(__dirname, 'module')
    });

    return migration.sync()
      .then(() => Table_1_0_0.findAll())
      .then(() => Table_1_0_1.findAll())
      .then(() => Table_1_1_0.findAll())
      .then(() => Migration.findAll({
        order: [['script_name', 'ASC']]
      }))
      .then(migrations => {
        expect(migrations).with.length(3);

        expect(migrations[0].module).equal('my-name');
        expect(migrations[0].execution_ts).to.not.be.undefined;
        expect(migrations[0].script_name).equal('V20161126203834__create_table_1_0_0.sql');
        expect(migrations[0].description).equal('create table 1 0 0');
        expect(migrations[0].version).equal('20161126203834');
        expect(migrations[0].success).equal(true);

        expect(migrations[1].module).equal('my-name');
        expect(migrations[1].execution_ts).to.not.be.undefined;
        expect(migrations[1].script_name).equal('V20161126204011__create_table_1_0_1.sql');
        expect(migrations[1].description).equal('create table 1 0 1');
        expect(migrations[1].version).equal('20161126204011');
        expect(migrations[1].success).equal(true);

        expect(migrations[2].module).equal('my-name');
        expect(migrations[2].execution_ts).to.not.be.undefined;
        expect(migrations[2].script_name).equal('V20161126204548__create_table_1_1_0.sql');
        expect(migrations[2].description).equal('create table 1 1 0');
        expect(migrations[2].version).equal('20161126204548');
        expect(migrations[2].success).equal(true);
      });
  });

  it('should update schema', async () => {
    const newScriptPathMysql = path.join(__dirname, 'module', 'mysql', 'V20161126204548__create_table_1_1_1.sql');
    const newScriptPathPostgres = path.join(__dirname, 'module', 'postgres', 'V20161126204548__create_table_1_1_1.sql');

    migration.addModule({
      name: 'my-name',
      dir: path.join(__dirname, 'module')
    });

    await migration.sync();
    await Table_1_0_0.findAll();
    await Table_1_0_1.findAll();
    await Table_1_1_0.findAll();
    const migrations = await Migration.findAll({
      order: [['script_name', 'ASC']]
    });

    expect(migrations).with.length(3);

    fs.writeFileSync(newScriptPathMysql, `
      CREATE TABLE table_1_1_1 (
        id bigint(20) NOT NULL AUTO_INCREMENT,
        name varchar(255) NOT NULL,
        PRIMARY KEY (id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
    `);

    fs.writeFileSync(newScriptPathPostgres, `
      CREATE TABLE table_1_1_1 (
        id BIGINT PRIMARY KEY NOT NULL,
        name VARCHAR(255) NOT NULL
      );
    `);

    await migration.sync();
    await Table_1_1_1.findAll();

    fs.unlinkSync(newScriptPathMysql);
    fs.unlinkSync(newScriptPathPostgres);
  });

});