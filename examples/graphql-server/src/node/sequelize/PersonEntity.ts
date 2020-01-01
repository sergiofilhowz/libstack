import { IsUUID, Model, PrimaryKey, Table, Column, Length } from 'sequelize-typescript';
import { SequelizeModel } from '@libstack/sequel';

@SequelizeModel
@Table({ tableName: 'person' })
export class PersonEntity extends Model<PersonEntity> {

  @IsUUID("4")
  @PrimaryKey
  @Column
  id: string;

  @Length({ min: 3, max: 32 })
  @Column({ field: 'first_name' })
  firstName: string;

  @Length({ min: 3, max: 32 })
  @Column({ field: 'last_name' })
  lastName: string;

  @Column
  age: number;

}