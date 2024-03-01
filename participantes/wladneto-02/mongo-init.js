db = db.getSiblingDB('rinha');

db.createCollection('clientes');
//db.createCollection('transacoes', { capped : true, size: 102400, max :100 });
db.createCollection('transacoes');

db.clientes.createIndex({ "clienteid": 1 }, { unique: true });
db.transacoes.createIndex({ "clienteid": 1 }, { unique: false });

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