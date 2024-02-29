import express from 'express';
import { Request, Response } from 'express';
import {z } from 'zod';
import { prisma } from './lib/prisma';

const app = express();
require('dotenv').config();
app.use(express.json());


app.get('/clientes/:id/extrato', async  (req: Request, res: Response) => {
    let statuscode = 200; // só para exibir o statuscode no console
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
        res.status(404).json({ error:'deu erro em alguma coisa dentro do try' });
    } finally{
        console.log("id do cliente:",parseInt(req.params.id), "status",statuscode);
    }
})



// Rota para criar transações de um cliente específico
app.post('/clientes/:id/transacoes', async  (req: Request, res: Response) => {
    let statuscode = 200; // só para exibir o statuscode no console
    let {saldo, limite} = {saldo: 0, limite: 0};
    try {
        // recebe i ID do cliente na requisição
        const clienteId = parseInt(req.params.id);
    
        // Verificando se o corpo da requisição não está vazio
        if (!req.body) {
            throw new Error('Corpo da requisição está vazio');
        }      

        // Verificando se o ID do cliente está dentro do intervalo esperado
        if (clienteId >= 1 && clienteId <= 5) {
            const createClienteBody = z.object({
                valor: z.number().int().positive(),
                tipo: z.string().max(1),
                descricao: z.string().max(10).min(1)
            })

            // desestrutura o corpo da requisição 
            const { valor, tipo, descricao } = createClienteBody.parse(req.body);

            // Busca o cliente no banco de dados
            const cliente = await prisma.cliente.findUnique({
                where:{id: clienteId}
            })

            // Verifica se o cliente foi encontrado
            if (!cliente) {
                throw new Error('Cliente não encontrado');
            }

            let newBalance = 0;
            // Verifica se o cliente foi encontrado
            if (tipo === 'd' || tipo === 'c') {
                // Calcula o novo saldo com base no tipo de transação
                if (tipo === 'd') {
                    newBalance = cliente.saldo - valor;
                } else if (tipo === 'c') {
                    newBalance = cliente.saldo + valor;
                }

                saldo = newBalance;
                limite = cliente?.limite;

                // Verifica se o novo saldo excede o limite
                if ((-1 * cliente.limite) > newBalance) {
                    statuscode = 422;
                    return res.status(422).json({ error: 'Transação não permitida pois excede o limite' });
                }
                
                await Promise.all([
                    // Cria a transação utilizando o Prisma Client
                    prisma.transacao.create({
                        data: {
                            valor: valor,
                            tipo: tipo,
                            descricao: descricao,
                            cliente_id: clienteId,
                            realizada_em: new Date()
                        }
                    }),

                    // Atualiza o saldo do cliente no banco de dados
                    prisma.cliente.update({
                        where: { id: clienteId },
                        data: { saldo: newBalance }
                    })                    
                ])


                // Retorna o saldo e o limite do cliente
                res.status(200).json( {limite: cliente.limite, saldo: newBalance});

            } else{
                statuscode = 422;
                throw new Error('Tipo de transação inválido');
            }
        } else {
            // Caso contrário, lançamos um erro com status 400 (Bad Request)
            console.log('ID de cliente inválido')
            statuscode = 404;            
            res.status(404).send('ID de cliente inválido');
        }

    } catch (error) {
        // Caso ocorra algum erro, retornamos uma resposta de erro
        console.error( error);
        statuscode = 404;
        res.status(404).json({ error: 'Erro ao criar transação, no catch.' });
    } finally{
        console.log('-------------------------------info da transação--------------------------------------- \n ', req.body," statuscode:",statuscode," \n -----------------------------Dados do cliente:",parseFloat(req.params.id),"------------------------------------ \n Saldo: ",saldo,"      Limite:",limite,"   \n  --------------------------------------------------------------------------------------");
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

