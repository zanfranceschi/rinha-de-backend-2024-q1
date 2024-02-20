CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    saldo INTEGER NOT NULL,
    limite INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    tipo CHAR(1) NOT NULL,
    realizada_em TIMESTAMP NOT NULL,
    id_cliente INTEGER NOT NULL
);

CREATE INDEX idx_transacoes_id_cliente ON transacoes (id_cliente);

CREATE TYPE criar_transacao_result AS (
  resultado integer,
  saldo integer,
  limite integer
);

CREATE FUNCTION criar_transacao(a_id_cliente INTEGER, valor INTEGER, descricao VARCHAR(10), tipo CHAR(1))
RETURNS criar_transacao_result AS $$
DECLARE 
  current_data RECORD;
  result criar_transacao_result;
  copy_valor INTEGER;
BEGIN
  PERFORM pg_advisory_xact_lock(a_id_cliente);
  SELECT * INTO current_data FROM transacoes WHERE id_cliente = a_id_cliente ORDER BY id DESC LIMIT 1;

  IF current_data IS NULL THEN
    SELECT -1, -1, -1 INTO result;
    RETURN result;
  END IF;

  IF tipo = 'd' THEN
    copy_valor := valor * -1;
  ELSE
    copy_valor := valor;
  END IF;

  IF copy_valor < 0 AND current_data.saldo + copy_valor < current_data.limite * -1 THEN
    SELECT -2, -2, -2 INTO result;
  ELSE
      INSERT INTO transacoes (saldo, limite, valor, descricao, tipo, realizada_em, id_cliente)
        VALUES (current_data.saldo + copy_valor, current_data.limite, valor, descricao, tipo, NOW(), a_id_cliente)
        RETURNING 0, saldo, limite INTO result;
  END IF;

  RETURN result;  
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
  INSERT INTO transacoes (id_cliente, saldo, limite, valor, descricao, tipo, realizada_em)
  VALUES
    (1, 0, 1000 * 100, 0, '', 'c', NOW()),
    (2, 0, 800 * 100, 0, '', 'c', NOW()),
    (3, 0, 10000 * 100, 0, '', 'c', NOW()),
    (4, 0, 100000 * 100, 0, '', 'c', NOW()),
    (5, 0, 5000 * 100, 0, '', 'c', NOW());
END; $$