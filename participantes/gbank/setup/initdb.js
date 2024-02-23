db = connect("mongodb://localhost/gbank");

// drop clientes and transacoes collections, if exist
db.clientes.drop();
db.transacoes.drop();

// insert 5 default clientes in collection
db.clientes.insertMany([
  { clienteId: 1, limite: 100000, saldo: 0 },
  { clienteId: 2, limite: 80000, saldo: 0 },
  { clienteId: 3, limite: 1000000, saldo: 0 },
  { clienteId: 4, limite: 10000000, saldo: 0 },
  { clienteId: 5, limite: 500000, saldo: 0 },
]);

// create indexes for clientes and transacoes collections
db.clientes.createIndex({ clienteId: 1 });
db.transacoes.createIndex({ clienteId: 1 });
