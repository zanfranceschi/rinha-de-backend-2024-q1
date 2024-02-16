db = connect('mongodb://localhost/rinha')

db.clients.insertMany([
    {
        id: 1,
        limite: 100000,
        saldo_inicial: 0
    },
    {
        id: 2,
        limite: 80000,
        saldo_inicial: 0
    },
    {
        id: 3,
        limite: 1000000,
        saldo_inicial: 0
    },
    {
        id: 4,
        limite: 10000000,
        saldo_inicial: 0
    },
    {
        id: 5,
        limite: 500000,
        saldo_inicial: 0
    },
])