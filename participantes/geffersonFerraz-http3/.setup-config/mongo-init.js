db = db.getSiblingDB('rinha');

db.createCollection('clientes');

db.clientes.createIndex({ id_cliente: 1 })

db.clientes.insertMany([
    {
        id_cliente: 1,
        saldo: 0,
        limit: 100000,
        tipo_transaction: '',
        valor: 0,
        description: '',
        created_at: new Date()
    },
    {
        id_cliente: 2,
        saldo: 0,
        limit: 80000,
        tipo_transaction: '',
        valor: 0,
        description: '',
        created_at: new Date()
    },
    {
        id_cliente: 3,
        saldo: 0,
        limit: 1000000,
        tipo_transaction: '',
        valor: 0,
        description: '',
        created_at: new Date()
    },
    {
        id_cliente: 4,
        saldo: 0,
        limit: 10000000,
        tipo_transaction: '',
        valor: 0,
        description: '',
        created_at: new Date()
    },
    {
        id_cliente: 5,
        saldo: 0,
        limit: 500000,
        tipo_transaction: '',
        valor: 0,
        description: '',
        created_at: new Date()
    }
]);

