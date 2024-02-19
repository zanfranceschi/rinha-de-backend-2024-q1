CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    debit_limit INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    value INTEGER NOT NULL,
    type CHAR(1) NOT NULL,
    description VARCHAR(10) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    customer_id INTEGER NOT NULL,
    CONSTRAINT fk_transaction_customer_id
        FOREIGN KEY (customer_id)
        REFERENCES customers (id)
);

CREATE TABLE IF NOT EXISTS balances (
    id SERIAL PRIMARY KEY,
    value INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    CONSTRAINT fk_balance_customer_id
        FOREIGN KEY (customer_id)
        REFERENCES customers (id)
);


INSERT INTO customers (customer_name, debit_limit)
VALUES
    ('joao', 1000 * 100),
    ('maria', 800 * 100),
    ('carlos', 10000 * 100),
    ('leticia', 100000 * 100),
    ('marcos', 5000 * 100);

INSERT INTO balances (value, customer_id)
    SELECT 0, id FROM customers;