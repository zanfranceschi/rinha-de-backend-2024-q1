import express from 'express';
import { Request, Response } from 'express';

// import { PrismaClient } from '@prisma/client';
// const prisma = new PrismaClient();

import { prisma } from './lib/prisma';

const app = express();
require('dotenv').config();

app.use(express.json());

// Defina a rota para listar os clientes
app.get('/', async (req: Request, res: Response) => {
    try {
        // resquest: req, response: res    // Busque todos os clientes no banco de dados usando o Prisma Client
        // const clientes = await prisma.clientes.findMany();

        // Retorne a lista de clientes como resposta
        // res.json(clientes);
        res.send('Hello World')
    } catch (error) {
        // Em caso de erro, retorne uma resposta de erro com status 500
        console.error('Erro ao buscar clientes:', error);
        res.status(500).json({ error: 'Erro ao buscar clientes.' });
    }
});

app.get('/clientes/:id/extrato', async  (req, res) => {
    const clienteId = parseInt(req.params.id); 
    // Verificando se o ID do cliente está dentro do intervalo esperado
    if (clienteId >= 1 && clienteId <= 5) {
        res.send("Extrato do cliente " + clienteId);
    } else {
        // Caso contrário, lançamos um erro com status 400 (Bad Request)
        res.status(400).send('ID de cliente inválido');
    }

})

// Rota para criar transações de um cliente específico
app.post('/clientes/:id/transacoes', async  (req, res) => {
    const clienteId = parseInt(req.params.id); 
    // Verificando se o ID do cliente está dentro do intervalo esperado
    if (clienteId >= 1 && clienteId <= 5) {
        try {
            
            // desestrutura o corpo da requisição 
            const { valor, tipo, descricao } = req.body;

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
        } catch (error) {
            // Caso ocorra algum erro, retornamos uma resposta de erro
            console.error('Erro ao criar transação:', error);
            res.status(500).json({ error: 'Erro ao criar transação.' });
        }
        console.log(clienteId) // mostra o id od cliente 
        console.log(req.body) // mostra o corpo da requisição

    } else {
        // Caso contrário, lançamos um erro com status 400 (Bad Request)
        res.status(404).send('ID de cliente inválido');
    }
})

app.listen(3000,() =>{
    console.log('Server is running on port 3000')
})

