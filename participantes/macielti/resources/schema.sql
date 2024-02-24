CREATE TABLE IF NOT EXISTS customer (
    customer_id INT PRIMARY KEY,
    customer_limit INT NOT NULL,
    customer_balance INT NOT NULL,
    CONSTRAINT check_balance CHECK (
        CASE
            WHEN customer_balance < 0 THEN NOT(ABS(customer_balance) > customer_limit)
            ELSE true
        END)
);

CREATE TABLE IF NOT EXISTS transaction (
    customer_id INT NOT NULL,
    amount INT NOT NULL,
    type VARCHAR(20) NOT NULL,
    description VARCHAR(255) NOT NULL,
    requested_at TIMESTAMP NOT NULL
);
