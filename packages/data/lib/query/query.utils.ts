import { AbstractDataTypeConstructor, DataTypes, ModelCtor } from 'sequelize';

const transformers: { [key:string]: Function } = {};

transformers[DataTypes.INTEGER.key] = (value:number|string) =>
  value && typeof value == 'string' ? parseInt(value, 10): value;

transformers[DataTypes.BIGINT.key] = (value:string|number) =>
  value != null ? value.toString() : null;

transformers[DataTypes.BOOLEAN.key] = (value:boolean|Buffer) =>
  value === null ? null : (value instanceof Buffer ? !!value.readInt8(0) : !!value);

export const getDeletedAtColumn = (model:ModelCtor<any>) => model.options.deletedAt || 'deletedAt';

export const getValue = (type:AbstractDataTypeConstructor, value:any) => {
  if (value == null) {
    return null;
  }
  const transformer:Function = transformers[type.key];
  return transformer ? transformer(value) : value;
};

export const getTableName = (model:ModelCtor<any>) => {
  const tableName = model.getTableName();
  return typeof tableName == 'string'
    ? tableName
    : `${tableName.schema}${tableName.delimiter}${tableName.tableName}`;
};

