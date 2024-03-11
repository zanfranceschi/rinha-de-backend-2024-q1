DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS transacoes;

CREATE TABLE IF NOT EXISTS clientes (
                                        id INTEGER PRIMARY KEY,
                                        limite INTEGER NOT NULL,
                                        saldo INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS transacoes (
                                          id SERIAL PRIMARY KEY,
                                          cliente_id INTEGER NOT NULL,
                                          tipo CHAR(1) NOT NULL,
                                          valor INTEGER NOT NULL,
                                          descricao VARCHAR(10) NOT NULL,
                                          realizada_em TIMESTAMPTZ NOT NULL
);

CREATE INDEX ON transacoes (cliente_id, realizada_em DESC);

INSERT INTO clientes
(id, limite, saldo)
VALUES
    (1, 100000,     0),
    (2, 80000,      0),
    (3, 1000000,    0),
    (4, 10000000,   0),
    (5, 500000,     0);

CREATE OR REPLACE FUNCTION update_saldo_cliente(id INT, valor INT, tipo VARCHAR, descricao VARCHAR)
RETURNS TABLE(new_saldo INT, limite INT) AS $$
DECLARE
  saldo INTEGER;
limite INTEGER;
new_saldo INTEGER;
BEGIN
SELECT c.saldo, c.limite INTO saldo, limite
FROM clientes c
WHERE c.id = update_saldo_cliente.id FOR UPDATE;

IF update_saldo_cliente.tipo = 'd' THEN
    new_saldo := saldo - update_saldo_cliente.valor;
IF new_saldo + limite < 0 THEN
      RAISE EXCEPTION 'Updating saldo failed: new saldo exceeds the limit' USING ERRCODE = 'P0000';
END IF;
ELSE
    new_saldo := saldo + update_saldo_cliente.valor;
END IF;

UPDATE clientes c SET saldo = new_saldo WHERE c.id = update_saldo_cliente.id;

INSERT INTO transacoes (cliente_id, tipo, valor, descricao, realizada_em)
VALUES (
           update_saldo_cliente.id,
           update_saldo_cliente.tipo,
           update_saldo_cliente.valor,
           update_saldo_cliente.descricao,
           CURRENT_TIMESTAMP
       );

RETURN QUERY SELECT new_saldo, limite;
END;
$$ LANGUAGE plpgsql;
