CREATE TABLE transacoes (
    transacao_id SERIAL PRIMARY KEY,
    transacao_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    limite INT,
    valor INT,
    valor_apos_transacao INT,
    transacao_type VARCHAR(1),
    descricao VARCHAR(10),
    client_id INT
);

CREATE INDEX idx_transacao_client ON transacoes(client_id, transacao_id DESC);

INSERT INTO transacoes (limite, valor, valor_apos_transacao, client_id, transacao_type) VALUES
(100000, 0, 0, 1, 's'),
(80000, 0, 0, 2, 's'),
(1000000, 0, 0, 3, 's'),
(10000000, 0, 0, 4, 's'),
(500000, 0, 0, 5, 's');


CREATE OR REPLACE FUNCTION process_transaction(fclient_id INT, valud_to_add INT, typeOp VARCHAR(1), description VARCHAR)
RETURNS TABLE(client_limit INT, client_balance INT) AS $$
DECLARE
    current_limit INT;
    current_value INT;
    new_value INT;
BEGIN
    valud_to_add := ABS(valud_to_add);

    SELECT limite, valor_apos_transacao INTO current_limit, current_value
    FROM transacoes
    WHERE client_id = process_transaction.fclient_id
    ORDER BY transacao_id DESC
    LIMIT 1
    FOR UPDATE;

    IF NOT FOUND THEN
        RETURN QUERY SELECT 0, 0;
		RETURN;
    END IF;

    IF typeOp = 'c' THEN
        new_value := current_value + valud_to_add;
    ELSIF typeOp = 'd' THEN
        new_value := current_value - valud_to_add;
    ELSE
        RAISE EXCEPTION 'Invalid transaction type: %', typeOp;
    END IF;

    IF typeOp = 'd' AND (new_value < 0 AND (new_value < current_limit * -1)) THEN
        RETURN QUERY SELECT -1, -1;
		RETURN;
    END IF;

    INSERT INTO transacoes (limite, valor, valor_apos_transacao, client_id, descricao, transacao_type)
    VALUES (current_limit, valud_to_add, new_value, process_transaction.fclient_id, description, typeOp);

    RETURN QUERY SELECT current_limit, new_value;
END;
$$ LANGUAGE plpgsql;

