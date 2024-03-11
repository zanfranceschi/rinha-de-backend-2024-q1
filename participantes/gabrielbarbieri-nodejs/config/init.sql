CREATE DATABASE rinha;

\c rinha;

CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    limit_amount INTEGER NOT NULL,
    balance INTEGER NOT NULL
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    account_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    transaction_type CHAR(1) NOT NULL,
    description VARCHAR(10) NOT NULL,
    date TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_accounts_transactions_id
        FOREIGN KEY (account_id) REFERENCES accounts(id)
);

INSERT INTO accounts (name, limit_amount, balance)
VALUES
    ('o barato sai caro', 1000 * 100, 0),
    ('zan corp ltda', 800 * 100, 0),
    ('les cruders', 10000 * 100, 0),
    ('padaria joia de cocaia', 100000 * 100, 0),
    ('kid mais', 5000 * 100, 0);

