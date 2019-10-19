import { IsUUID, Model, PrimaryKey, Table, Column, Length } from 'sequelize-typescript';
import { SequelizeModel } from '@libstack/sequel';

@SequelizeModel
@Table({ tableName: 'person' })
export class Person extends Model<Person> {

  @IsUUID("4")
  @PrimaryKey
  @Column
  id: string;

  @Length({ min: 3, max: 32 })
  @Column
  first_name: string;

  @Length({ min: 3, max: 32 })
  @Column
  last_name: string;

  @Column
  age: number;

}