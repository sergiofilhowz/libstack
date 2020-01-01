import {
  IsUUID,
  Model,
  PrimaryKey,
  Table,
  Column,
  Length,
  BelongsTo,
  AutoIncrement,
  ForeignKey
} from 'sequelize-typescript';
import { SequelizeModel } from '@libstack/sequel';
import { Address } from './Address';

@SequelizeModel
@Table({ tableName: 'person' })
export class Person extends Model<Person> {

  @AutoIncrement
  @PrimaryKey
  @Column
  id: number;

  @IsUUID("4")
  @Column
  uuid: string;

  @Length({ min: 3, max: 32 })
  @Column({ field: 'first_name' })
  firstName: string;

  @Length({ min: 3, max: 32 })
  @Column({ field: 'last_name' })
  lastName: string;

  @Column
  age: number;

  @ForeignKey(() => Address)
  @Column
  address_id: number;

  @BelongsTo(() => Address)
  address:Address;

}