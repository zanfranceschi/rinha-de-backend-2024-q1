db = connect("mongodb://localhost/rinhabackenddb");

db.clientes.insertMany([
  {
    id: 1,
    limite: 100000,
    saldo: 0,
    disponivel: 100000,
    ultimas_transacoes: [],
  },
  {
    id: 2,
    limite: 80000,
    saldo: 0,
    disponivel: 80000,
    ultimas_transacoes: [],
  },
  {
    id: 3,
    limite: 1000000,
    saldo: 0,
    disponivel: 1000000,
    ultimas_transacoes: [],
  },
  {
    id: 4,
    limite: 10000000,
    saldo: 0,
    disponivel: 10000000,
    ultimas_transacoes: [],
  },
  {
    id: 5,
    limite: 500000,
    saldo: 0,
    disponivel: 500000,
    ultimas_transacoes: [],
  },
]);
