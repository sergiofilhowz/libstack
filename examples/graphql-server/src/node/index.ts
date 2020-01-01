import { ApolloServer } from 'apollo-server-express';
import { Server } from '@libstack/server';
import { database } from '@libstack/sequel';
import { join } from 'path';

import { buildSchema } from 'type-graphql';
import { GraphQLSchema } from 'graphql';
import { PersonResolver } from './resolvers/PersonResolver';

const server = new Server();

database.loadMigrations({ dir: join(process.cwd(), 'src', 'db') });
server.beforeStartup(async () => {
  const schema: GraphQLSchema = await buildSchema({
    resolvers: [PersonResolver],
  });
  const apolloServer = new ApolloServer({ schema, playground: true });
  await database.sync();

  apolloServer.applyMiddleware({ app: server.app });
});

export default server;
