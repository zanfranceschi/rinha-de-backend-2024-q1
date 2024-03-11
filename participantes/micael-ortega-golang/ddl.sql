-- Create users table
CREATE UNLOGGED TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    balance INT NOT NULL,
    account_limit INT NOT NULL DEFAULT 0
);

-- Create transactions table
CREATE UNLOGGED TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    value INT NOT NULL,
    kind VARCHAR(1) NOT NULL,
    description VARCHAR(10) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Create index for transactions table
CREATE INDEX idx_client_id_transactions ON transactions (client_id, timestamp DESC);

-- Function to get bank statement
CREATE OR REPLACE FUNCTION fn_get_last_transactions(var_id INT) RETURNS TABLE (
    fn_res_balance INT,
    fn_res_account_limit INT,
    fn_res_timestamp TIMESTAMP WITHOUT TIME ZONE,
    fn_res_value INT,
    fn_res_kind VARCHAR(1),
    fn_res_description VARCHAR(10),
    fn_res_transaction_timestamp TIMESTAMP,
    fn_res_code INT
) AS $$
BEGIN
    PERFORM 1 FROM users WHERE id = var_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT
            0,
            0,
            CURRENT_TIMESTAMP AT TIME ZONE 'UTC',
            0,
            ''::VARCHAR,
            ''::VARCHAR,
            CURRENT_TIMESTAMP AT TIME ZONE 'UTC',
            -1;
    END IF;

    RETURN QUERY SELECT
        u.balance,
        u.account_limit,
        CURRENT_TIMESTAMP AT TIME ZONE 'UTC',
        t.value,
        t.kind,
        t.description,
        t.timestamp,
        1
    FROM
        users u
    LEFT JOIN
        transactions t ON t.client_id = u.id
    WHERE
        u.id = var_id
    ORDER BY
        t.timestamp DESC
    LIMIT 10;
END;
$$ LANGUAGE plpgsql;

-- Function for crediting
CREATE OR REPLACE FUNCTION fn_credit(
    fn_client_id INT,
    fn_description VARCHAR(10),
    fn_kind VARCHAR(1),
    fn_value INT
) RETURNS TABLE (
    fn_res_limit INT,
    fn_res_balance INT,
    fn_res_code INT
) AS $$
DECLARE
    var_balance INT;
    var_limit INT;
BEGIN
    PERFORM pg_advisory_xact_lock(fn_client_id);
    
    SELECT balance, account_limit INTO var_balance, var_limit
    FROM users
    WHERE id = fn_client_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT 0, 0, 3;
    END IF;
    
    INSERT INTO transactions (client_id, description, kind, value)
    VALUES (fn_client_id, fn_description, fn_kind, fn_value);
        
    UPDATE users
    SET balance = balance + fn_value
    WHERE id = fn_client_id
    RETURNING account_limit, balance, 1
    INTO fn_res_limit, fn_res_balance, fn_res_code;
    
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

-- Function for debiting
CREATE OR REPLACE FUNCTION fn_debit(
    fn_client_id INT,
    fn_description VARCHAR(10),
    fn_kind VARCHAR(1),
    fn_value INT
) RETURNS TABLE (
    fn_res_limit INT,
    fn_res_balance INT,
    fn_res_code INT
) AS $$
DECLARE
    var_balance INT;
    var_limit INT;
BEGIN
    PERFORM pg_advisory_xact_lock(fn_client_id);
    
    SELECT balance, account_limit INTO var_balance, var_limit
    FROM users
    WHERE id = fn_client_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT 0, 0, 3;
    END IF;
    
    IF var_balance - fn_value >= var_limit * -1 THEN
        INSERT INTO transactions (client_id, description, kind, value)
        VALUES (fn_client_id, fn_description, fn_kind, fn_value);
        
        UPDATE users
        SET balance = balance - fn_value
        WHERE id = fn_client_id
        RETURNING account_limit, balance, 1
        INTO fn_res_limit, fn_res_balance, fn_res_code;

        RETURN NEXT;
    ELSE
        RETURN QUERY SELECT var_limit, var_balance, 2;
    END IF;
END;
$$ LANGUAGE plpgsql;
