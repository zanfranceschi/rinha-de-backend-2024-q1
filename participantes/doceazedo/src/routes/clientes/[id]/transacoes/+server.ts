import { z } from 'zod';
import { eq, sql } from 'drizzle-orm';
import { error, json } from '@sveltejs/kit';
import { db } from '$db';
import { clientes, transacoes } from '$db/schema';
import { validateId, validateRequest } from '$utils/validation';

export const POST = async ({ params, request }) => {
	const id = await validateId(params.id);
	const body = await validateRequest(
		request,
		z.object({
			valor: z.number().int().positive(),
			tipo: z.string().refine((x) => ['c', 'd'].includes(x), {
				message: 'Tipo da transação deve ser "c" ou "d"'
			}),
			descricao: z.string().min(1).max(10)
		})
	);

	let cliente: typeof clientes.$inferSelect;
	try {
		const result = await db.select().from(clientes).where(eq(clientes.id, id));
		if (!result.length) throw Error();
		cliente = result[0];
	} catch (err) {
		console.error(err);
		return error(404, 'Cliente não encontrado');
	}

	let novoSaldo = 0;
	if (body.tipo === 'd') {
		const saldoMinimo = cliente.limite * -1;
		novoSaldo = cliente.saldo - body.valor;
		if (novoSaldo < saldoMinimo) {
			return error(422, 'Limite insuficiente');
		}
	} else if (body.tipo === 'c') {
		novoSaldo = cliente.saldo + body.valor;
	}

	let clienteAtualizado: Omit<typeof clientes.$inferSelect, 'id'>;
	try {
		const result = await db
			.update(clientes)
			.set({ saldo: novoSaldo })
			.where(eq(clientes.id, cliente.id))
			.returning({ saldo: clientes.saldo, limite: clientes.limite });
		if (!result.length) throw Error();
		clienteAtualizado = result[0];
	} catch (err) {
		console.error(err);
		throw error(500, 'Não foi possível atualizar o saldo do cliente');
	}

	try {
		await db.insert(transacoes).values({
			valor: body.valor,
			tipo: body.tipo as 'c' | 'd',
			descricao: body.descricao,
			id_cliente: cliente.id
		});
	} catch (err) {
		console.error(err);
		return error(500, 'Não foi possível registrar a transação');
	}

	return json(clienteAtualizado);
};
