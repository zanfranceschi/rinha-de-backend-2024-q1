db = db.getSiblingDB('admin');

db.createCollection('clientes');
db.createCollection('transacoes');

db.clientes.insertMany([
 {
    _id: 1,
    nome: 'o barato sai caro',
    limite: 100000,
    saldo: 0
  },
  {
    _id: 2,
    nome: 'zan corp ltda',
    limite: 80000,
    saldo: 0
  },
  {
    _id: 3,
    nome: 'les cruders',
    limite: 1000000,
    saldo: 0
  },
  {
    _id: 4,
    nome: 'padaria joia de cocaia',
    limite: 10000000,
    saldo: 0
  },
  {
    _id: 5,
    nome: 'kid mais',
    limite: 500000,
    saldo: 0
  },
]);