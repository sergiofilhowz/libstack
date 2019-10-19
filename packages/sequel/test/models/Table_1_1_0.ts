import { SequelizeModel } from '../..';
import { Column, AutoIncrement, Model, PrimaryKey, Table } from 'sequelize-typescript';

@SequelizeModel
@Table({ tableName: 'table_1_1_0', timestamps: false })
export class Table_1_1_0 extends Model<Table_1_1_0> {

  @AutoIncrement
  @PrimaryKey
  @Column
  id: number;

  @Column
  name: string;

}