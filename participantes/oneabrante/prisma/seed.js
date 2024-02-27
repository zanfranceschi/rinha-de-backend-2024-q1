import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
    const clientes = [
        { nome: 'o barato sai caro ', limite: 1000 * 100, saldo: 0 },
        { nome: 'zan corp ltda', limite: 800 * 100, saldo: 0 },
        { nome: 'les cruders', limite: 10000 * 100, saldo: 0 },
        { nome: 'padaria joia de cocaia', limite: 100000 * 100, saldo: 0},
        { nome: 'kid mais', limite: 5000 * 100, saldo: 0}
    ];

    for (const cliente of clientes) {
        await prisma.cliente.create({
            data: cliente,
        });
    }
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
   })
    .finally(async () => {
        await prisma.$disconnect();
   });