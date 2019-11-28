import { Server } from '@libstack/server';
import { database } from '@libstack/sequel';
import { join } from 'path';
import './routers/PersonRouter';

const server = new Server();

database.loadMigrations({ dir: join(process.cwd(), 'src', 'db') });
server.beforeStartup(database.sync);

export default server;
