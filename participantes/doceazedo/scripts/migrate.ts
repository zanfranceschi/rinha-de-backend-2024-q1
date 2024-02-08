import { client, db } from './db';
import { migrate } from 'drizzle-orm/node-postgres/migrator';

console.log('Migrating...');
await migrate(db, { migrationsFolder: './drizzle' });

console.log('Migration finished succesfully! ✅');
await client.end();

console.log('Goodbye! 👋');
