CREATE TABLE IF NOT EXISTS account
(
    id            SERIAL PRIMARY KEY,
    max_limit     INT NOT NULL,
    balance       INT NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions
(
    id            SERIAL PRIMARY KEY,
    id_account    INTEGER NOT NULL REFERENCES account,
    amount        INT NOT NULL,
    kind          VARCHAR(1) NOT NULL,
    description   VARCHAR(255) NOT NULL,
    created_at    TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_account_transaction_created_at ON transactions (created_at);

INSERT INTO account (max_limit, balance) VALUES (100000, 0);
INSERT INTO account (max_limit, balance) VALUES (80000, 0);
INSERT INTO account (max_limit, balance) VALUES (1000000, 0);
INSERT INTO account (max_limit, balance) VALUES (10000000, 0);
INSERT INTO account (max_limit, balance) VALUES (500000, 0);