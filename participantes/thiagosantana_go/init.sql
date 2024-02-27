CREATE TABLE clientes (
     id SERIAL PRIMARY KEY,
     limite INTEGER NOT NULL,
     saldo INTEGER NOT NULL
);

CREATE TABLE transacoes (
  id SERIAL PRIMARY KEY,
  cliente_id INTEGER REFERENCES clientes(id),
  valor INTEGER NOT NULL,
  tipo VARCHAR NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  data VARCHAR NOT NULL
);

insert into clientes
(id, limite, saldo)
values
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0)