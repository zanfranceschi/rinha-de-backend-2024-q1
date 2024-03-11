CREATE UNLOGGED TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL,
	saldo INTEGER DEFAULT 0
);

CREATE UNLOGGED TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX CONCURRENTLY idx_transacoes_cliente_id
	ON transacoes (cliente_id);

DO $$
BEGIN
	INSERT INTO clientes (nome, limite, saldo)
	VALUES
		('o barato sai caro', 1000 * 100, 0),
		('zan corp ltda', 800 * 100, 0),
		('les cruders', 10000 * 100, 0),
		('padaria joia de cocaia', 100000 * 100, 0),
		('kid mais', 5000 * 100, 0);
	
END;
$$;

CREATE OR REPLACE FUNCTION debitar(
	cliente_id_tx INT,
	valor_tx INT,
	descricao_tx VARCHAR(10))
RETURNS RECORD
LANGUAGE plpgsql
AS $$
DECLARE
	record RECORD;
	_limite int;
	_saldo int;
 	success int;
BEGIN
	PERFORM pg_advisory_xact_lock(cliente_id_tx);
	
  UPDATE clientes
     SET saldo = saldo - valor_tx
   WHERE id = cliente_id_tx
     AND ABS(saldo - valor_tx) <= limite
RETURNING saldo, limite INTO _saldo, _limite;

	GET DIAGNOSTICS success = ROW_COUNT;

	IF success THEN
		INSERT INTO transacoes (cliente_id, valor, tipo, descricao)
		VALUES (cliente_id_tx, valor_tx, 'd', descricao_tx);

		SELECT success, _saldo, _limite INTO record;
  ELSE 
  	SELECT 0, saldo, limite
      FROM clientes
     WHERE id = cliente_id_tx
      INTO record;
	END IF;
  
  RETURN record;
END;
$$;

CREATE OR REPLACE FUNCTION creditar(
	cliente_id_tx INT,
	valor_tx INT,
	descricao_tx VARCHAR(10))
RETURNS TABLE (
	novo_saldo INT,
	_limite INT)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO transacoes
		VALUES(DEFAULT, cliente_id_tx, valor_tx, 'c', descricao_tx, NOW());

	RETURN QUERY
		UPDATE clientes
		SET saldo = saldo + valor_tx
		WHERE id = cliente_id_tx
		RETURNING saldo, limite;
END;
$$;
