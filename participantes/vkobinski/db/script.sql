DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS saldo;
DROP TABLE IF EXISTS transacao;

CREATE TABLE cliente (
    cliente_id SERIAL PRIMARY KEY

);

CREATE TABLE saldo (
    saldo_id SERIAL PRIMARY KEY,
    cliente_id SERIAL,
    total INT NOT NULL,
    limite INT NOT NULL,
    CONSTRAINT fk_cliente
        FOREIGN KEY(cliente_id)
            REFERENCES cliente(cliente_id)
);

CREATE TABLE transacao (
    transacao_id SERIAL PRIMARY KEY,
    cliente_id SERIAL,
    valor INT NOT NULL,
    tipo VARCHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMPTZ NOT NULL,
    CONSTRAINT fk_transacao_cliente
        FOREIGN KEY(cliente_id)
            REFERENCES cliente(cliente_id)
);

DO $$
BEGIN
  INSERT INTO cliente (cliente_id)
  VALUES
    (1),
    (2),
    (3),
    (4),
    (5);
END; $$;

DO $$
BEGIN
  INSERT INTO saldo (cliente_id, limite, total)
  VALUES
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);
END; $$
