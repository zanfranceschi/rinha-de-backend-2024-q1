ALTER DATABASE rinha SET TIMEZONE TO 'UTC';

CREATE UNLOGGED TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    "limit" INTEGER NOT NULL,
    balance INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE "transaction" (
    transaction_id SERIAL PRIMARY KEY,
    value INTEGER NOT NULL,
    description VARCHAR(10) NOT NULL,
    type VARCHAR(1) NOT NULL,
    customer_id INTEGER NOT NULL,
    created_at TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

INSERT INTO customer (name, "limit")
VALUES
('o barato sai caro', 1000 * 100),
('zan corp ltda', 800 * 100),
('les cruders', 10000 * 100),
('padaria joia de cocaia', 100000 * 100),
('kid mais', 5000 * 100);


CREATE OR REPLACE FUNCTION process_transaction(
    p_customer_id INT,
    p_transaction_value INT,
    p_description VARCHAR(10),    
    p_type VARCHAR(1)
)
RETURNS TABLE (
    customer_limit INT,
    customer_balance INT,
    error_code INT,
    error_description VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE
    customer_limit INT;
    customer_balance INT;
    error_code INT;
    error_description VARCHAR(50);
begin
    -- lock by customer id
    PERFORM pg_advisory_xact_lock(p_customer_id); 

    -- Fetch customer limit and balance from the database
    SELECT "limit", balance INTO customer_limit, customer_balance
    FROM customer
    WHERE customer_id = p_customer_id;
      
    IF customer_limit IS NULL THEN
        error_code = 1;
        error_description = 'Cliente não existe';    
        RETURN QUERY SELECT 0, 0, 1 AS error_code, error_description;
        RETURN; -- exit 
    END IF;

    IF p_type = 'c' THEN 
        customer_balance := customer_balance + p_transaction_value;
    ELSE 
        customer_balance := customer_balance + (p_transaction_value * -1);
        -- Check if the transaction value exceeds the customer's limit    
        IF ABS(customer_balance) > customer_limit THEN
            error_code = 2;
            error_description = 'Transação excede o limite do cliente';
            RETURN QUERY SELECT customer_limit, customer_balance, error_code, error_description;
            RETURN; -- exit 
        END IF; 
    END IF;
    
    -- Insert transaction
    INSERT INTO "transaction" (value, description, type, customer_id, created_at) 
    VALUES (p_transaction_value, p_description, p_type, p_customer_id, NOW());

    -- Update customer balance
    UPDATE customer SET balance = customer_balance WHERE customer_id = p_customer_id;

    -- Return updated limit and balance
    error_code = 0;
    error_description = '';   
    RETURN QUERY SELECT customer_limit, customer_balance, error_code, error_description;
END;
$$