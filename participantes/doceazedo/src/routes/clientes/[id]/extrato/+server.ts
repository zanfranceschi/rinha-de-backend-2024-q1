import { desc, eq } from 'drizzle-orm';
import { error, json } from '@sveltejs/kit';
import { db } from '$db';
import { clientes, transacoes } from '$db/schema';
import { validateId } from '$utils/validation';

export const GET = async ({ params }) => {
	const id = await validateId(params.id);

	let cliente: typeof clientes.$inferSelect;
	try {
		const result = await db.select().from(clientes).where(eq(clientes.id, id));
		if (!result.length) throw Error();
		cliente = result[0];
	} catch (err) {
		console.error(err);
		return error(404, 'Cliente não encontrado');
	}

	let ultimasTransacoes: Omit<typeof transacoes.$inferSelect, 'id' | 'id_cliente'>[];
	try {
		ultimasTransacoes = await db
			.select({
				valor: transacoes.valor,
				tipo: transacoes.tipo,
				descricao: transacoes.descricao,
				realizada_em: transacoes.realizada_em
			})
			.from(transacoes)
			.where(eq(transacoes.id_cliente, cliente.id))
			.orderBy(desc(transacoes.realizada_em))
			.limit(10);
	} catch (err) {
		return error(500, 'Não foi possível buscar transções do cliente');
	}

	return json({
		saldo: {
			total: cliente.saldo,
			data_extrato: new Date().toISOString(),
			limite: cliente.limite
		},
		ultimas_transacoes: ultimasTransacoes
	});
};
