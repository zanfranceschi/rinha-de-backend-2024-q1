CREATE TABLE clientes (
  id serial not null primary key,
  nome varchar(100) not null,
  limite bigint not null default 0,
  saldo bigint not null default 0
);

CREATE TABLE transacoes (
  id serial not null primary key,
  valor bigint not null,
  tipo char(1) not null,
  descricao varchar(10),
  realizada_em timestamp not null default CURRENT_TIMESTAMP,
  cliente_id integer not null references clientes (id)
);

CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id);

DO $$
BEGIN
  INSERT INTO clientes (nome, limite)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$