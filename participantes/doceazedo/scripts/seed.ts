import { client, db } from './db';
import { clientes, transacoes } from '../src/db/schema';

console.log('Delete existing data...');
try {
	await db.delete(transacoes);
	await db.delete(clientes);
} catch (err) {
	console.log(err);
	console.log('Could not delete existing existing data ❌');
	await client.end();
	process.exit(1);
}

console.log('Checking if data was already created...');
try {
	const result = await db.select().from(clientes);
	if (result.length) {
		console.log('Database already have data, skipping! 👋');
		await client.end();
		process.exit(0);
	}
} catch (err) {
	console.error(err);
	console.log('Could not fetch existing data before seeding ❌');
	await client.end();
	process.exit(1);
}

console.log('Database is empty, inserting initial data...');
try {
	await db.insert(clientes).values([
		{ id: 1, limite: 100000 },
		{ id: 2, limite: 80000 },
		{ id: 3, limite: 1000000 },
		{ id: 4, limite: 10000000 },
		{ id: 5, limite: 500000 }
	]);
	console.log('Seeding finished succesfully! ✅');
} catch (err) {
	console.error(err);
	console.log('Could not seed database, perhaps the data already exists? ❌');
}

await client.end();
console.log('Goodbye! 👋');
