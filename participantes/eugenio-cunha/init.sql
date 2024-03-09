CREATE UNLOGGED TABLE IF NOT EXISTS client (
    id SERIAL PRIMARY KEY,
    "limit" integer NOT NULL,
    balance integer DEFAULT 0 NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_client ON client (id asc);

CREATE UNLOGGED TABLE IF NOT EXISTS client_transaction (
    id SERIAL PRIMARY KEY,
    client_id smallint NOT NULL,
    amount integer NOT NULL,
    "type" character(1) NOT NULL,
    "description" character varying(10) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_client_transaction ON client_transaction (id asc);
CREATE INDEX IF NOT EXISTS idx_client_transaction_created_at_1 ON client_transaction (client_id, created_at DESC) WHERE client_id = 1;
CREATE INDEX IF NOT EXISTS idx_client_transaction_created_at_2 ON client_transaction (client_id, created_at DESC) WHERE client_id = 2;
CREATE INDEX IF NOT EXISTS idx_client_transaction_created_at_3 ON client_transaction (client_id, created_at DESC) WHERE client_id = 3;
CREATE INDEX IF NOT EXISTS idx_client_transaction_created_at_4 ON client_transaction (client_id, created_at DESC) WHERE client_id = 4;
CREATE INDEX IF NOT EXISTS idx_client_transaction_created_at_5 ON client_transaction (client_id, created_at DESC) WHERE client_id = 5;

DROP PROCEDURE IF EXISTS process_transaction(integer, character varying, integer, character varying);
CREATE OR REPLACE PROCEDURE process_transaction(
	IN p_id integer,
	IN p_type character varying,
	IN p_amount integer,
	IN p_description character varying,
	OUT p_limit integer,
	OUT p_balance integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
  v_balance integer DEFAULT 0;
BEGIN
  SELECT c.limit, c.balance FROM client AS c WHERE c.id = p_id INTO p_limit, p_balance FOR UPDATE;
  
  IF p_type = 'd' THEN
    v_balance = p_balance - p_amount;
  ELSE
    v_balance = p_balance + p_amount;
  END IF;
  
  IF v_balance < (p_limit * -1) THEN
    RAISE EXCEPTION 'denied' using errcode = '422';
  END IF;
  
  UPDATE client
  SET balance = v_balance WHERE client.id = p_id;
	
  p_balance = v_balance;
	
  INSERT INTO client_transaction (
    client_id,
    amount,
    "type",
    "description",
	created_at
  ) VALUES (
	p_id, 
	p_amount, 
	p_type, 
	p_description, 
	CURRENT_TIMESTAMP
  );
END;
$BODY$;

DROP FUNCTION IF EXISTS process_balance(integer);
CREATE OR REPLACE FUNCTION process_balance(
	p_id integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    v_result JSON;
BEGIN
    SELECT jsonb_build_object(
        'saldo', jsonb_build_object(
            'limite', c.limit,
            'total', c.balance,
            'data_extrato', CURRENT_TIMESTAMP
        ),
        'ultimas_transacoes', (
            SELECT jsonb_agg(to_jsonb(transaction_by_client))
            FROM (
                SELECT
                    t.amount AS valor,
                    t.type AS tipo,
                    t.description AS descricao,
                    t.created_at AS realizada_em
                FROM client_transaction AS t
                WHERE t.client_id = p_id
                ORDER BY t.created_at DESC
                LIMIT 10
            ) AS transaction_by_client
        )
    ) INTO v_result
    FROM client as c
    WHERE c.id = p_id
    FOR UPDATE;

    RETURN v_result;
END;
$BODY$;

DO $$
BEGIN
  INSERT INTO client ("limit", balance)
  VALUES
    (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);
END; $$