CREATE TABLE cliente (
  id INT PRIMARY KEY,
  limite BIGINT NOT NULL,
  saldo BIGINT NOT NULL
);

CREATE TABLE transacao (
  id SERIAL PRIMARY KEY,
  id_cliente INT NOT NULL,
  valor BIGINT NOT NULL,
  tipo CHAR(1) NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  realizado_em TIMESTAMP WITH TIME ZONE NOT NULL,
  saldo BIGINT NOT NULL
);

CREATE INDEX transacao_index ON transacao (
  id_cliente
);

INSERT INTO cliente (id, limite, saldo) VALUES (1, 100000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (2, 80000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (3, 1000000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (4, 10000000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (5, 500000, 0);
