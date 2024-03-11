CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    debit_limit INTEGER NOT NULL,
    balance INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    type CHAR(1) NOT NULL,
    description VARCHAR(10) NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE INDEX idx_transactions_client_id ON transactions(client_id);

INSERT INTO clients (debit_limit)
SELECT *
FROM (
  VALUES
  (100000),
  (80000),
  (1000000),
  (10000000),
  (500000)
) AS temp_values
WHERE NOT EXISTS (SELECT 1 FROM clients);

CREATE OR REPLACE FUNCTION insert_transaction_and_update_balance(
	p_client_id integer,
	p_amount integer,
	p_type character,
	p_description character varying
) RETURNS jsonb AS $$
DECLARE
    current_balance INTEGER;
    current_debit_limit INTEGER;
    new_balance INTEGER;
    result jsonb;
BEGIN
    PERFORM pg_advisory_xact_lock(p_client_id);

    SELECT c.balance, c.debit_limit
	INTO current_balance, current_debit_limit
	FROM clients c
	WHERE id = p_client_id;

	IF NOT FOUND THEN
    	RAISE EXCEPTION 'CLIENT_NOT_FOUND';
  	END IF;

    new_balance := CASE
        WHEN p_type = 'd'
        THEN current_balance - p_amount
        ELSE current_balance + p_amount
    END;

    IF new_balance >= - current_debit_limit THEN
        INSERT INTO transactions (client_id, amount, type, description)
        VALUES (p_client_id, p_amount, p_type, p_description);

        UPDATE clients
        SET balance = new_balance
        WHERE id = p_client_id;
    ELSE
        RAISE EXCEPTION 'DEBIT_LIMIT_EXCEEDED';
    END IF;

    PERFORM pg_advisory_unlock(p_client_id);

    result := jsonb_build_object(
        'limite', current_debit_limit,
        'saldo', new_balance
    );

	RETURN result;
EXCEPTION
    WHEN others THEN
        RAISE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_client_balance_and_last_ten_transactions(
    p_client_id INTEGER
)
RETURNS jsonb AS $$
DECLARE
    client_json jsonb;
    transactions_json jsonb;
    combined_result jsonb;
BEGIN
    PERFORM pg_advisory_xact_lock(p_client_id);

    select jsonb_build_object(
        'limite', debit_limit,
		'total', balance,
        'data_extrato', localtimestamp
    )
	INTO client_json
	FROM clients
	WHERE id = p_client_id;

	IF NOT FOUND THEN
    	RAISE EXCEPTION 'CLIENT_NOT_FOUND';
  	END IF;

    SELECT coalesce(
		jsonb_agg(
			jsonb_build_object(
				'valor', amount,
            	'tipo', type,
            	'descricao', description,
            	'realizada_em', timestamp
        	)
    	),
		'[]'::jsonb
	)
	INTO transactions_json
    FROM (
		SELECT amount, type, description, timestamp
		FROM transactions
		WHERE client_id = p_client_id
		ORDER BY timestamp DESC
		LIMIT 10
	);

    PERFORM pg_advisory_unlock(p_client_id);

    combined_result := jsonb_build_object(
		'saldo', client_json,
		'ultimas_transacoes', transactions_json
	);

    RETURN combined_result;
END;
$$ LANGUAGE plpgsql;

