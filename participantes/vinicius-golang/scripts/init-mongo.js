// init-mongo.js

db = db.getSiblingDB('rinha');

// Insira seus registros aqui
db.clientes.insertMany([
  { user_id: "1", limite: 1000 * 100, saldo: 0 },
  { user_id: "2", limite: 800 * 100, saldo: 0 },
  { user_id: "3", limite: 10000 * 100, saldo: 0 },
  { user_id: "4", limite: 100000 * 100, saldo: 0 },
  { user_id: "5", limite: 5000 * 100, saldo: 0 }
]);
