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
  descricao_tx VARCHAR(10)
)
RETURNS jsonb
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

    RETURN (
      SELECT row_to_json(t) AS data
      FROM (
        SELECT _saldo as saldo, _limite as limite
      ) t
    );
  ELSE
    RETURN NULL;
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION creditar(
  cliente_id_tx INT,
  valor_tx INT,
  descricao_tx VARCHAR(10)
)
RETURNS jsonb
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO transacoes
    VALUES (DEFAULT, cliente_id_tx, valor_tx, 'c', descricao_tx, NOW());

  UPDATE clientes
  SET saldo = saldo + valor_tx
  WHERE id = cliente_id_tx;

  RETURN (
    SELECT row_to_json(t) AS data
    FROM (
      SELECT saldo, limite
      FROM clientes
      WHERE id = cliente_id_tx
    ) t
  );
END;
$$;

CREATE OR REPLACE FUNCTION extrato(
	clienteId INT
) 
RETURNS jsonb 
LANGUAGE plpgsql AS $$
DECLARE
  cd RECORD;
BEGIN
  
 RETURN (
  	SELECT 
   	 json_object(
     		'saldo' VALUE json_object(
				'total' VALUE saldo, 
				'limite' VALUE limite, 
				'data_extrato' VALUE current_timestamp
			),
       		'ultimas_transacoes' VALUE COALESCE(json_agg(t) FILTER (WHERE t.cliente_id IS NOT NULL), '[]')
     )
    FROM clientes c
    LEFT JOIN (
		SELECT t1.* 
		  FROM transacoes t1 
		 WHERE t1.cliente_id = clienteId 
		 ORDER BY t1.id DESC 
		 LIMIT 10
	) t ON t.cliente_id = c.id
    WHERE c.id = clienteId
    GROUP BY c.id
 );
  
  
END;
$$;
