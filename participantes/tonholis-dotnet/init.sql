CREATE UNLOGGED TABLE IF NOT EXISTS customers (
    "id"                SERIAL,
    "account_limit"     INT NOT NULL,
    "balance"           INT DEFAULT 0,

    PRIMARY KEY (id)
);

CREATE UNLOGGED TABLE IF NOT EXISTS transactions (
    "id"           SERIAL,
    "customer_id"  INT NOT NULL,
    "amount"       INT NOT NULL,
    "type"         VARCHAR(1) NOT NULL,
    "description"  VARCHAR(10) NOT NULL,
    "created_at"   TIMESTAMP,
    
    CONSTRAINT "customer_fk" FOREIGN KEY ("customer_id") REFERENCES customers("id")
);

CREATE INDEX idx_transactions_created_at ON transactions (created_at);
CREATE INDEX idx_transactions_customer_id ON transactions (customer_id);

DO $$
BEGIN
  INSERT INTO customers ("account_limit")
  VALUES
    (1000 * 100),
    (800 * 100),
    (10000 * 100),
    (100000 * 100),
    (5000 * 100);
END; $$;

CREATE OR REPLACE FUNCTION add_transaction(
    p_customer_id INT,
    p_amount INT,
    p_type VARCHAR(1),
    p_description VARCHAR(10)
)
RETURNS TABLE (id INT, account_limit INT, balance INT, error INT) AS $$
DECLARE
    v_limit INT;
    v_balance INT;
BEGIN
    -- Lock the customer row for update
    SELECT c.balance, c.account_limit INTO v_balance, v_limit
    FROM customers as c
    WHERE c.id = p_customer_id
    FOR UPDATE;

    IF NOT FOUND THEN
        -- RAISE EXCEPTION 'E001: Customer does not exist.';
        RETURN QUERY SELECT 0, 0, 0, 1;
        RETURN;
    END IF;

    -- Check customer's balance & limit
    IF p_type = 'c' THEN
        v_balance := v_balance + p_amount;        
    ELSIF p_type = 'd' THEN
        IF v_balance - p_amount < v_limit * -1 THEN
            -- RAISE EXCEPTION 'E002: Insufficient balance for debit transaction.';
            RETURN QUERY SELECT 0, 0, 0, 2;
            RETURN;
        ELSE
            v_balance := v_balance - p_amount;            
        END IF;
    END IF;

    -- Insert the transaction
    INSERT INTO transactions (customer_id, amount, type, description, created_at)
    VALUES (p_customer_id, p_amount, p_type, p_description, NOW());

    -- Update the transaction
    UPDATE customers as c 
    SET balance = v_balance 
    WHERE c.id = p_customer_id;

    -- Return the updated customer details
    RETURN QUERY SELECT p_customer_id, v_limit, v_balance, 0;
END;
$$ LANGUAGE plpgsql;
