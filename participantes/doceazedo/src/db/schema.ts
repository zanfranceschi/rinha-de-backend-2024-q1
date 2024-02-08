import { index, integer, pgEnum, pgTable, serial, timestamp, varchar } from 'drizzle-orm/pg-core';

export const tipoTransacaoEnum = pgEnum('tipo_transacao', ['c', 'd']);

export const clientes = pgTable('clientes', {
	id: serial('id').primaryKey(),
	limite: integer('limite').default(0).notNull(),
	saldo: integer('saldo').default(0).notNull()
});

export const transacoes = pgTable(
	'transacoes',
	{
		id: serial('id').primaryKey(),
		id_cliente: integer('id_cliente').references(() => clientes.id),
		valor: integer('valor').default(0).notNull(),
		tipo: tipoTransacaoEnum('tipo_transacao'),
		descricao: varchar('descricao', { length: 10 }),
		realizada_em: timestamp('realizada_em').defaultNow()
	},
	(table) => ({
		id_cliente_idx: index('id_cliente_idx').on(table.id_cliente)
	})
);
