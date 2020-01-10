import {
  IsUUID,
  Model,
  PrimaryKey,
  Table,
  Column,
  Length,
  AutoIncrement,
  ForeignKey,
  BelongsTo
} from 'sequelize-typescript';
import { SequelizeModel } from '@libstack/sequel';
import { City } from './City';

@SequelizeModel
@Table({ tableName: 'address' })
export class Address extends Model<Address> {

  @AutoIncrement
  @PrimaryKey
  @Column
  id: number;

  @IsUUID("4")
  @Column
  uuid: string;

  @Length({ min: 3, max: 32 })
  @Column
  street: string;

  @Column
  number: number;

  @ForeignKey(() => City)
  @Column({ field: 'city_id' })
  cityId: number;

  @BelongsTo(() => City)
  city:City;

}