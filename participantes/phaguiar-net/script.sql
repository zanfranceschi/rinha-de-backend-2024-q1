CREATE UNLOGGED TABLE transactions (
    transaction_id                SERIAL PRIMARY KEY,
    client_id                     INTEGER NOT NULL,
    client_limit                  INTEGER NOT NULL,
    client_current                INTEGER NOT NULL,
    transaction_value             INTEGER NOT NULL,
    transaction_type              CHAR(1)     NOT NULL,
    transaction_description       VARCHAR(10) NOT NULL,
    transaction_date              TIMESTAMP   NOT NULL,
    transaction_logical_counter   INTEGER  NOT NULL
);

ALTER TABLE transactions ADD CONSTRAINT unique_transaction_logical_counter UNIQUE (client_id, transaction_logical_counter);

CREATE INDEX idx_transactions_client_id_date ON transactions (client_id, transaction_logical_counter DESC);

INSERT INTO transactions (client_id, client_limit, client_current, transaction_value, transaction_type, transaction_description, transaction_date, transaction_logical_counter)
VALUES 
    (1, 1000 * 100, 0, 0, 'n', 'Created', NOW(), 0),
    (2, 800 * 100, 0, 0, 'n', 'Created', NOW(), 0),
    (3, 10000 * 100, 0, 0, 'n', 'Created', NOW(), 0),
    (4, 100000 * 100, 0, 0, 'n', 'Created', NOW(), 0),
    (5, 5000 * 100, 0, 0, 'n', 'Created', NOW(), 0)
;

CREATE OR REPLACE FUNCTION create_transaction_for_client(
    p_client_id integer,
    p_transaction_value integer,
    p_transaction_type character,
    p_transaction_description character varying,
    OUT result_code integer,
    OUT out_client_limit integer,
    OUT out_client_current integer)
RETURNS RECORD
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_retry BOOLEAN := TRUE;
    v_logical_counter INTEGER;
BEGIN
    WHILE v_retry LOOP
        -- Retrieve the latest transaction for the given client_id
        SELECT client_limit, client_current, transaction_logical_counter INTO out_client_limit, out_client_current, v_logical_counter
        FROM transactions
        WHERE client_id = p_client_id
        ORDER BY transaction_logical_counter DESC
        LIMIT 1;

        -- Check if there's no transaction found
        IF NOT FOUND THEN
            result_code := 1; -- Indicate an error or invalid client_id
            RETURN;
        END IF;

        -- Calculate the potential new client_current
        out_client_current := out_client_current + p_transaction_value;

        -- Check if the transaction would cause client_current to go below -1 * client_limit
        IF out_client_current < (-1 * out_client_limit) THEN
            result_code := 2; -- Indicate transaction would exceed limit
            RETURN;
        END IF;

        BEGIN
            INSERT INTO transactions (client_id, client_limit, client_current, transaction_value, transaction_type, transaction_description, transaction_date, transaction_logical_counter)
            VALUES (p_client_id, out_client_limit, out_client_current, p_transaction_value, p_transaction_type, p_transaction_description, NOW(), v_logical_counter + 1);

            v_retry := FALSE;
            result_code := 0;
        EXCEPTION WHEN unique_violation THEN
        END;
    END LOOP;
END;
$$;

CREATE OR REPLACE FUNCTION get_client_transactions(p_client_id INTEGER)
RETURNS TABLE(
    client_limit INTEGER,
    client_current INTEGER,
    transaction_value INTEGER,
    transaction_type CHAR(1),
    transaction_description VARCHAR(10),
    transaction_date TIMESTAMP
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    RETURN QUERY
    SELECT t.client_limit, t.client_current, t.transaction_value, t.transaction_type, t.transaction_description, t.transaction_date
    FROM transactions t
    WHERE t.client_id = p_client_id
    ORDER BY t.transaction_logical_counter DESC;
END;
$$;

CREATE OR REPLACE FUNCTION wipe_all_transactions()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    TRUNCATE TABLE transactions;
    INSERT INTO transactions (client_id, client_limit, client_current, transaction_value, transaction_type, transaction_description, transaction_date, transaction_logical_counter)
    VALUES 
        (1, 1000 * 100, 0, 0, 'n', 'Created', NOW(), 0),
        (2, 800 * 100, 0, 0, 'n', 'Created', NOW(), 0),
        (3, 10000 * 100, 0, 0, 'n', 'Created', NOW(), 0),
        (4, 100000 * 100, 0, 0, 'n', 'Created', NOW(), 0),
        (5, 5000 * 100, 0, 0, 'n', 'Created', NOW(), 0)
    ;
END;
$$;

CREATE OR REPLACE PROCEDURE prune_transactions(p_client_id INTEGER)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_threshold_counter INTEGER;
BEGIN
    SELECT transaction_logical_counter INTO v_threshold_counter
    FROM transactions
    WHERE client_id = p_client_id
    ORDER BY transaction_logical_counter DESC
    LIMIT 1 OFFSET 11;

    IF v_threshold_counter IS NULL THEN
        RETURN;
    END IF;

    DELETE FROM transactions
    WHERE client_id = p_client_id AND transaction_logical_counter < v_threshold_counter;
END;
$$;