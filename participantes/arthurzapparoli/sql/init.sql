CREATE UNLOGGED TABLE clientes (
	id SMALLSERIAL PRIMARY KEY,
	saldo INTEGER NOT NULL,
	limite INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transacoes (
  id SERIAL PRIMARY KEY,
  cliente_id SMALLINT NOT NULL,
  valor SMALLINT NOT NULL,
  tipo CHAR(1) NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
  CONSTRAINT chave_cliente_id FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id);

CREATE OR REPLACE FUNCTION debitar(
  param_cliente_id SMALLINT,
  param_valor SMALLINT,
  param_descricao VARCHAR(10),
  OUT resultado_codigo SMALLINT,
  OUT resultado_saldo INTEGER,
  OUT resultado_limite INTEGER
)
AS $$
BEGIN
  -- initialize out parameters
  resultado_codigo := 0; -- assume success
  resultado_saldo := NULL;
  resultado_limite := NULL;

  -- check if the client exists and fetch their balance_limit
  SELECT limite INTO resultado_limite FROM clientes WHERE id = param_cliente_id;

  IF resultado_limite IS NULL THEN
    resultado_codigo := 1; -- client does not exist
    RETURN;
  END IF;

  -- attempt to update the client's balance only if the new balance is within limits
  UPDATE clientes SET saldo = saldo - param_valor 
  WHERE id = param_cliente_id AND saldo - param_valor >= -limite
  RETURNING saldo INTO resultado_saldo;

  -- insert the record if the update was successful
  IF NOT FOUND THEN
    resultado_codigo := 2; -- Update failed due to balance constraints.
  ELSE
    INSERT INTO transacoes (
      cliente_id,
      valor,
      tipo,
      descricao,
      realizada_em)
    VALUES (
      param_cliente_id,
      param_valor,
      'd',
      param_descricao,
      NOW()
    );

    resultado_codigo := 0; -- success
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION creditar(
  param_cliente_id SMALLINT,
  param_valor SMALLINT,
  param_descricao VARCHAR(10),
  OUT resultado_codigo SMALLINT,
  OUT resultado_saldo INTEGER,
  OUT resultado_limite INTEGER
)
AS $$
BEGIN
  -- initialize out parameters
  resultado_codigo := 0; -- assume success
  resultado_saldo := NULL;
  resultado_limite := NULL;

  -- check if the client exists and fetch their balance_limit
  SELECT limite INTO resultado_limite FROM clientes WHERE id = param_cliente_id;

  IF resultado_limite IS NULL THEN
    resultado_codigo := 1; -- client does not exist
    RETURN;
  END IF;

  UPDATE clientes SET saldo = saldo + param_valor 
  WHERE id = param_cliente_id
  RETURNING saldo INTO resultado_saldo;

  INSERT INTO transacoes (
    cliente_id,
    valor,
    tipo,
    descricao,
    realizada_em)
  VALUES (
    param_cliente_id,
    param_valor,
    'c',
    param_descricao,
    NOW()
  );

  resultado_codigo := 0; -- success
END;
$$ LANGUAGE plpgsql;

BEGIN;
  INSERT INTO clientes (id, saldo, limite) VALUES (1, 0, 100000);
  INSERT INTO clientes (id, saldo, limite) VALUES (2, 0, 80000);
  INSERT INTO clientes (id, saldo, limite) VALUES (3, 0, 1000000);
  INSERT INTO clientes (id, saldo, limite) VALUES (4, 0, 10000000);
  INSERT INTO clientes (id, saldo, limite) VALUES (5, 0, 500000);
END;
