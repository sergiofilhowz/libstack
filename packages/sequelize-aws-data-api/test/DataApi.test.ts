import { expect } from 'chai';
import { DataTypes, Sequelize } from 'sequelize';
import { enableDataAPI } from '../lib';

// @ts-ignore
const sequelize = new Sequelize({
  logging: console.log,
  dialect: process.env.DIALECT,
});

enableDataAPI(sequelize, {
  region: process.env.DATA_API_REGION,
  database: process.env.DATA_API_DATABASE,
  resourceArn: process.env.DATA_API_RESOURCE_ARN,
  secretArn: process.env.DATA_API_SECRET_ARN
});

const SomeTable: any = sequelize.define('SomeTable', {
  id: { type: DataTypes.BIGINT, primaryKey: true, autoIncrement: true },
  timestampField: { field: 'timestamp_field', type: DataTypes.DATE },
  stringField: { field: 'string_field', type: DataTypes.STRING },
  numberField: { field: 'number_field', type: DataTypes.INTEGER },
  booleanField: { field: 'boolean_field', type: DataTypes.BOOLEAN },
  floatField: { field: 'float_field', type: DataTypes.FLOAT(8, 2) },
}, {
  timestamps: false,
  paranoid: false,
  tableName: 'some_table'
});

describe('Data API', () => {


  describe('Sync', () => {
    it('should sync table', async () => {
      await SomeTable.sync({ force: true });
    });

    it('should drop tables', async () => {
      await SomeTable.sync({ force: true });
      await sequelize.getQueryInterface().dropAllTables({ force: true });
    });
  });


  describe('Populate and Select', () => {
    beforeEach(() => SomeTable.sync({ force: true }));

    it('should insert rows and perform raw queries', async () => {
      const result = await SomeTable.create({
        timestampField: new Date(),
        stringField: 'hello there',
        numberField: 100,
        booleanField: true,
        floatField: 15.3
      });
      expect(result.id).equals(1);
      expect(result.stringField).equals('hello there');
      expect(result.timestampField).exist;
      expect(result.numberField).equals(100);
      expect(result.booleanField).equals(true);
      expect(result.floatField).equals(15.3);

      const item = await SomeTable.findByPk(result.id);

      expect(item.id).equals(result.id);
      expect(item.stringField).equals(result.stringField);
      expect(item.timestampField).equals(result.timestampField);
      expect(item.numberField).equals(result.numberField);
      expect(item.booleanField).equals(result.booleanField);
      expect(item.floatField).equals(result.floatField);

      const queryResult = await sequelize.query(`
        SELECT 
          id,
          timestamp_field,
          string_field,
          number_field,
          boolean_field,
          float_field
        FROM some_table
      `);
      expect(queryResult).with.length(1);
      expect(queryResult[0]).to.have.property('id').equals(result.id);
      expect(queryResult[0]).to.have.property('string_field').equals(result.stringField);
      expect(queryResult[0]).to.have.property('timestamp_field').equals(result.timestampField);
      expect(queryResult[0]).to.have.property('number_field').equals(result.numberField);
      expect(queryResult[0]).to.have.property('boolean_field').equals(result.booleanField);
      expect(queryResult[0]).to.have.property('float_field').equals(result.floatField);
    });
  });
});