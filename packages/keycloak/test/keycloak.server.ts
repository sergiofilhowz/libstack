import { Server } from '@libstack/server';
import '../lib/keycloak';
import './routers/TestRouter';

const server = new Server();

export default server;
