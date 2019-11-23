# @libstack/server

### Routers
These are the Resources, the REST API. For example this:

```typescript
import { RestController, GET, POST, PUT, DELETE, NotFoundError } from '@libstack/router';
import AddressService from '../services/AddressService';

@RestController('/address')
export default class AddressRouter {

  @GET('/:uuid')
  async findAddress({ params }) {
    const address = await AddressService.find(params.uuid);
    if (!address) throw new NotFoundError('Address not Found');
    return address;
  }

  @POST('/')
  async createAddress({ body }) {
    const address = await AddressService.create(body);
    return AddressModel.find(address.uuid);
  }

  @PUT('/:uuid')
  async updateAddress({ params, body }) {
    await AddressService.update(params.uuid, body);
  }

  @DELETE('/:uuid')
  async deleteAddress({ params }) {
    await AddressService.deleteAddress(params.uuid);
  }

}
```

### index.ts

```typescript
import { Server } from '@libstack/server';
import './routers/PersonRouter';

const server = new Server();

server.beforeStartup(async () => {
  // put your async process to run on startup
});

export default server;
```

Using `@libstack/server` with `@libstack/sequel`

```typescript
import { Server } from '@libstack/server';
import { database } from '@libstack/sequel';
import { join } from 'path';
import './routers/PersonRouter';

const server = new Server();

// this will load all migrations from the migration folder
database.loadMigrations({ dir: join(__dirname, '..', 'db') });
server.beforeStartup(database.sync);

export default server;
```