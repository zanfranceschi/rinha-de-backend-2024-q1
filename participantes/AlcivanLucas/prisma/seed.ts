import {PrismaClient} from '@prisma/client';

const prisma = new PrismaClient();

const firstClientId = 1
const secondClientId = 2
const thirdClientId = 3
const fourthClientId = 4
const fifthClientId = 5

async function run () {
    const search = await prisma.cliente.findUnique({
        where: {id: firstClientId}
    })
    if(!search){
        await Promise.all([
            prisma.cliente.create({
                data:{
                    id: firstClientId,
                    limite: 100000,
                    saldo: 0
                }
            }),
            prisma.cliente.create({
                data:{
                    id: secondClientId,
                    limite: 80000,
                    saldo: 0
                }
            }),
            prisma.cliente.create({
                data:{
                    id: thirdClientId,
                    limite: 1000000,
                    saldo: 0
                }
            }),
            prisma.cliente.create({
                data:{
                    id: fourthClientId,
                    limite: 10000000,
                    saldo: 0
                }
            }),
            prisma.cliente.create({
                data:{
                    id: fifthClientId,
                    limite: 500000,
                    saldo: 0                   
                }
            })
        ])
    }else{
        console.log('Clientes já existem')
    }
}

run()
    .then(async () => {
        await prisma.$disconnect()
    })
    .catch(async (e) => {
        console.error(e)
        await prisma.$disconnect()
        process.exit(1)
    })