db = db.getSiblingDB('rinha');
db.clientes.insertMany([
    {
        _id: 1,
        Saldo: 0,
        Limite: 100000,
        Transacoes: []
    },
    {
        _id: 2,
        Saldo: 0,
        Limite: 80000,
        Transacoes: []
    },
    {
        _id: 3,
        Saldo: 0,
        Limite: 1000000,
        Transacoes: []
    },
    {
        _id: 4,
        Saldo: 0,
        Limite: 10000000,
        Transacoes: []
    },
    {
        _id: 5,
        Saldo: 0,
        Limite: 500000,
        Transacoes: []
    }
]);