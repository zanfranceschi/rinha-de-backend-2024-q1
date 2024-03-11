CREATE TABLE IF NOT EXISTS clientes (
  id serial primary key,
  nome varchar(255) not null,
  limite bigint not null,
  saldo bigint not null,
  versao integer not null default 0
);

CREATE TABLE IF NOT EXISTS transacoes (
  id serial primary key,
  cliente_id integer not null,
  valor bigint not null,
  tipo char not null,
  descricao varchar not null,
  realizada_em timestamp not null,
  FOREIGN KEY(cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes (id, nome, limite, saldo) VALUES
(1, 'Cliente 1', 100000, 0),
(2, 'Cliente 2', 80000, 0),
(3, 'Cliente 3', 1000000, 0),
(4, 'Cliente 4', 10000000, 0),
(5, 'Cliente 5', 500000, 0);