import { ModelCtor, Sequelize } from 'sequelize';
import squel from 'squel';

export const get = (model: ModelCtor<any>) => getBySequelize(model.sequelize);

export function getBySequelize(sequelize: Sequelize) {
  switch (sequelize.getDialect()) {
    case 'postgres':
      squel.cls.DefaultQueryBuilderOptions.tableAliasQuoteCharacter = '"';
      squel.cls.DefaultQueryBuilderOptions.fieldAliasQuoteCharacter = '"';
      squel.cls.DefaultQueryBuilderOptions.nameQuoteCharacter = '';
      squel.cls.DefaultQueryBuilderOptions.autoQuoteAliasNames = true;
      squel.cls.DefaultQueryBuilderOptions.autoQuoteTableNames = true;
      squel.cls.DefaultQueryBuilderOptions.autoQuoteFieldNames = true;
      return squel;
    case 'mysql':
      return squel;
    default:
      return squel;
  }
}