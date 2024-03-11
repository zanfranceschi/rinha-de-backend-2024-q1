conn = new Mongo();
db = conn.getDB("rinha");

db.accounts.drop();

db.accounts.insertMany(
  [
    {
      "_id": 1,
      "saldo": {
        "total": 0,
        "limite": 100000
      },
      "ultimas_transacoes": [],
      "gordurinha": 100000
    },
    {
      "_id": 2,
      "saldo": {
        "total": 0,
        "limite": 80000
      },
      "ultimas_transacoes": [],
      "gordurinha": 80000
    },
    {
      "_id": 3,
      "saldo": {
        "total": 0,
        "limite": 1000000
      },
      "ultimas_transacoes": [],
      "gordurinha": 1000000
    },
    {
      "_id": 4,
      "saldo": {
        "total": 0,
        "limite": 10000000
      },
      "ultimas_transacoes": [],
      "gordurinha": 10000000
    },
    {
      "_id": 5,
      "saldo": {
        "total": 0,
        "limite": 500000
      },
      "ultimas_transacoes": [],
      "gordurinha": 500000
    }

  ]
);
