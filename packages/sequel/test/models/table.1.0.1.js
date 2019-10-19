module.exports = function (sequelize, { BIGINT, STRING }) {
  return sequelize.define('Table_1_0_1', {
    id: { type: BIGINT, primaryKey: true, autoIncrement: true },
    name: STRING
  }, {
    timestamps: false,
    paranoid: false,
    tableName: 'table_1_0_1'
  });
};