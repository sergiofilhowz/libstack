# @libstack/data
This module will help you create better queries on your database using the power of `sequelize`.

## Installing

```
npm install @libstack/data --save
```

## Using

So lets supose you have a Model on your application (Lets call it Address).

````typescript
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
import { City } from './City';

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
  @Column
  city_id: number;

  @BelongsTo(() => City)
  city:City;

}
````

And Address has a City

```typescript
import { IsUUID, Model, PrimaryKey, Table, Column, Length, AutoIncrement } from 'sequelize-typescript';

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
```

In the next section you will create a repository to retrieve data easily from these models above and you can define whatever interface you want and `@libstack/data` will create the query only with the properties needed.

## Creating Projections
You can create projections on your models to return from the API only what is important.

```typescript
import { Property, Projection } from '@libstack/data';

@Projection
export class CityResponse {
  @Property uuid: string;
  @Property name: string;
}

@Projection
export class AddressResponse {
  @Property uuid: string;
  @Property street: string;
  @Property number: number;
  @Property city: CityResponse;
}
```

You can also change variable names if you want

```typescript
import { Property, Projection } from '@libstack/data';

@Projection
export class CityResponse {
  @Property uuid: string;
  @Property({ property: 'name' })
  thisIsMyCustomName: string;
}
```

You can also map the values into other values

```typescript
import { Property, Projection } from '@libstack/data';

@Projection
export class CityResponse {
  @Property uuid: string;
  @Property({ property: 'name', transform: (value:string) => value === 'My Town' })
  isMyTown: boolean;
}
```

Now, lets write the model and start using. You will need to create the Model class

```typescript
import { DataModel } from '@libstack/data';
import { Address } from '../sequelize/Person';

class AddressDataModel extends DataModel {
  constructor() {
    super(Address);
  }
}
```

Now lets start using the DataModel. The code bellow will return a list of the type you defined.

```typescript
const dataModel: AddressDataModel = new AddressDataModel();
const result:Array<AddressResponse> = await dataModel.list({
  projection: AddressResponse
});
```

## Filtering
And what about filtering? You can define criterias which are filters and some can be optional, some can be required.

```typescript
import { Criteria, Operators } from '@libstack/data';

const { EQUAL, GREATER_THAN, ILIKE, LESS_THAN } = Operators;

export class AddressCriteria {
  @Criteria({ property: 'address.city.name', operator: ILIKE })
  city?: string;

  @Criteria({ operator: EQUAL })
  number?: number;

  @Criteria({ operator: GREATER_THAN, property: 'number' })
  numbers_higher_than?: number;

  @Criteria({ operator: LESS_THAN, property: 'number' })
  numbers_than_than?: number;
}

export class AddressUuidCriteria {
  @Criteria({ operator: EQUAL })
  uuid: string;
}
```

And now you can start creating filters

```typescript
let result: AddressResponse [] = await dataModel.list({
  projection: AddressResponse,
  criteria: {
    reference: AddressCriteria,
    query: { number: 150 }
  }
});
```

Or requesting a single row based on the `AddressUuidCriteria`

```typescript
let result: AddressResponse = await dataModel.single({
  projection: AddressResponse,
  criteria: {
    reference: AddressUuidCriteria,
    query: { uuid: 'a1881f13-3f71-4771-9c3d-d3317c4cdaaf' }
  }
});
```

## Sorting
All properties you define are sortable. All you need to do is use the sort on list. 

```typescript
let result: AddressResponse [] = await dataModel.list({
  projection: AddressResponse,
  sort: 'street'
});
```

## Paging
You can request pages which will perform a count query based on the criteria (if there's one) and will create a paged result.

```typescript
const result:Page<AddressResponse> = await dataModel.page({
  pageSize: 1,
  page: 1,
  projection: AddressResponse,
});
```

A page have the following properties

```json
{
  "list": [],
  "count": 0,
  "page": 1,
  "pages": 0
}
```

