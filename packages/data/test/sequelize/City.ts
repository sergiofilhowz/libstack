import { IsUUID, Model, PrimaryKey, Table, Column, Length, AutoIncrement } from 'sequelize-typescript';
import { SequelizeModel } from '@libstack/sequel';

@SequelizeModel
@Table({ tableName: 'city' })
export class City extends Model<City> {

  @AutoIncrement
  @PrimaryKey
  @Column
  id: number;

  @IsUUID("4")
  @Column
  uuid: string;

  @Length({ min: 3, max: 32 })
  @Column
  name: string;

}