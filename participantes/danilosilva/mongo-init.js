db = db.getSiblingDB('Crebito');

db.createCollection('clientes');

db.clientes.insertMany([
    {
        clienteid: 1,
        limite: 100000,
        saldo: 0
    },
    {
        clienteid: 2,
        limite: 80000,
        saldo: 0
    },
    {
        clienteid: 3,
        limite: 1000000,
        saldo: 0
    },
    {
        clienteid: 4,
        limite: 10000000,
        saldo: 0
    },
    {
        clienteid: 5,
        limite: 500000,
        saldo: 0
    },
]);