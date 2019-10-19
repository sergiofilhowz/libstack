const Sequelize = require('sequelize');

module.exports = new Sequelize(process.env.DBNAME, process.env.USER, process.env.PASS, {
  dialect: process.env.DIALECT || 'mysql',
  sync: { force: false },
  dialectOptions: { socketPath: process.env.SOCKET },
  syncOnAssociation: true,
  host: process.env.DBHOST,
  port: process.env.DBPORT,
  logging: process.env.DEBUG ? console.log : false,

  define: {
    underscored: true,
    freezeTableName: false,
    syncOnAssociation: true,
    charset: 'utf8',
    collate: 'utf8_general_ci',
    timestamps: true,
    constraints: false,

    updatedAt: 'updated_at',
    createdAt: 'created_at',
    deletedAt: 'removed_at',

    paranoid: false
  },
});