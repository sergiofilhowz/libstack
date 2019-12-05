import { IsUUID, Model, PrimaryKey, Table, Column, Length, BeforeCreate } from 'sequelize-typescript';
import { SequelizeModel } from '@libstack/sequel';
import uuidv4 from 'uuid/v4';

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

  @BeforeCreate
  static generateUUID(instance: Person) {
    instance.id = uuidv4();
  }

}