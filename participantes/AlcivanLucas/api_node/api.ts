import express from 'express';
import { Request, Response } from 'express';
import {z } from 'zod';
import { prisma } from './lib/prisma';

const app = express();
require('dotenv').config();
app.use(express.json());


app.get('/clientes/:id/extrato', async  (req: Request, res: Response) => {
    try{
        const clienteId = parseInt(req.params.id);
        const data_extrato = new Date();

        // Verificando se o ID do cliente está dentro do intervalo esperado
        if (clienteId >= 1 && clienteId <= 5) {
            const saldo = await prisma.cliente.findUnique({
                where:{
                    id : clienteId
                }
            })
            const transacoes = await prisma.transacao.findMany({
                where: {
                    cliente_id: clienteId
                },orderBy:{
                    realizada_em: 'desc'
                }, take: 10 
            });

            // Removendo os atributos id e cliente_id das transacoes
            const ultimas_transacoes = transacoes.map((transacao) => {
                const { id, cliente_id, ...ultimas_transacoes } = transacao;
                return ultimas_transacoes;
            });

            res.status(200).json({
                saldo:{
                    total: saldo?.saldo, // o operador ? é só pra não lançar erro caso o valor seja nulo
                    data_extrato: data_extrato,
                    limite: saldo?.limite
                }, ultimas_transacoes
            });
        } else {
            // Caso contrário, lançamos um erro com status 400 (Bad Request)
            res.status(404).send('ID de cliente inválido');
        }
    }catch{
        res.status(404).json({ error:'deu erro' });
    }
})

// Rota para criar transações de um cliente específico
app.post('/clientes/:id/transacoes', async  (req: Request, res: Response) => {
    try {
        const clienteId = parseInt(req.params.id);
        // Verificando se o ID do cliente está dentro do intervalo esperado
        if (clienteId >= 1 && clienteId <= 5) {
            const createClienteBody = z.object({
                valor: z.number().int().positive(),
                tipo: z.string().max(1),
                descricao: z.string().max(10).min(1)
            })

            // desestrutura o corpo da requisição 
            const { valor, tipo, descricao } = createClienteBody.parse(req.body);


            // Verificando se o corpo da requisição não está vazio
            if (!req.body) {
                throw new Error('Corpo da requisição está vazio');
            }
            
            // Busca o cliente no banco de dados
            const cliente = await prisma.cliente.findUnique({
                where:{id: clienteId}
            })


            // Verifica se o cliente foi encontrado
            if (!cliente) {
                throw new Error('Cliente não encontrado');
            }

            // Cria a transação utilizando o Prisma Client
            await prisma.transacao.create({
                data: {
                    valor: valor,
                    tipo: tipo,
                    descricao: descricao,
                    cliente_id: clienteId,
                    realizada_em: new Date()
                }
            });

            // Calcula o novo saldo com base no tipo de transação
            let newBalance;
            if (tipo === 'd') {
                newBalance =  cliente.saldo - valor ;
            } else if (tipo === 'c') {
                newBalance =  cliente.saldo + valor ;
            } else {
                throw new Error('Tipo de transação inválido');
            }

            if ((-1 * cliente.limite) > newBalance){
                console.log("transação não permitida pois execede o limite")
                return res.status(422).json({ error: 'Transação não permitida pois excede o limite' });
            }

            // Atualiza o saldo do cliente no banco de dados
            await prisma.cliente.update({
                where: { id: clienteId },
                data: { saldo: newBalance }
            });

            res.status(200).json( {limite: cliente.limite,
                                    saldo: newBalance       
            });
            // console.log(clienteId) // mostra o id od cliente 
            // console.log(req.body) // mostra o corpo da requisição

        } else {
            // Caso contrário, lançamos um erro com status 400 (Bad Request)
            res.status(404).send('ID de cliente inválido');
        }
    } catch (error) {
        // Caso ocorra algum erro, retornamos uma resposta de erro
        console.error('Erro ao criar transação:', error);
        res.status(404).json({ error: 'Erro ao criar transação.' });
    }
})

try {
    app.listen(8080,() =>{
    console.log('Server is running on port 8080')
    }) 
}
catch (error) {
    console.error(error);
    process.exit(1);
  }

