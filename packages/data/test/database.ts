import { database } from '@libstack/sequel';
import { join } from 'path';

database.loadMigrations({ dir: join(__dirname, 'db') });

export default database;