CREATE TABLE clientes (
  id serial4 NOT NULL,
  nome varchar(50) NOT NULL,
  limite int4 NOT NULL,
  saldo int4 NOT NULL DEFAULT 0,
  CONSTRAINT clientes_pkey PRIMARY KEY (id)
);

CREATE TABLE transacoes (
  id serial4 NOT NULL,
  cliente_id int4 NOT NULL,
  valor int4 NOT NULL DEFAULT 0,
  descricao varchar(10) NOT NULL,
  tipo varchar(1) NOT NULL,
  realizada_em date NOT NULL DEFAULT 'now' :: text :: date,
  CONSTRAINT transacoes_pkey PRIMARY KEY (id)
);

INSERT INTO
  clientes (nome, limite)
VALUES
  ('o barato sai caro', 1000 * 100);

INSERT INTO
  clientes (nome, limite)
VALUES
  ('zan corp ltda', 800 * 100);

INSERT INTO
  clientes (nome, limite)
VALUES
  ('les cruders', 10000 * 100);

INSERT INTO
  clientes (nome, limite)
VALUES
  ('padaria joia de cocaia', 100000 * 100);

INSERT INTO
  clientes (nome, limite)
VALUES
  ('kid mais', 5000 * 100);