import 'dotenv/config';
import { drizzle } from 'drizzle-orm/node-postgres';
import { Client } from 'pg';

export const client = new Client({
	host: process.env.DB_HOST,
	port: parseInt(`${process.env.DB_PORT || '5432'}`),
	user: process.env.DB_USER,
	password: process.env.DB_PASSWORD,
	database: process.env.DB_DATABASE
});

console.log('Connecting...');
await client.connect();

export const db = drizzle(client);
