CREATE TABLE accounts(
    client_id     INTEGER NOT NULL CONSTRAINT pk_accounts PRIMARY KEY,
    balance       INTEGER NOT NULL,
    account_limit INTEGER NOT NULL
);

CREATE TABLE account_transactions(
    id               INTEGER     NOT NULL CONSTRAINT pk_account_transactions PRIMARY KEY,
    client_id        INTEGER     NOT NULL CONSTRAINT fk_account_transactions REFERENCES accounts,
    amount           INTEGER     NOT NULL,
    transaction_type VARCHAR(1)  NOT NULL,
    description      VARCHAR(10) NOT NULL,
    occurred_at       TIMESTAMP   NOT NULL
);

CREATE SEQUENCE seq_account_id;
CREATE SEQUENCE seq_account_transaction_id;

CREATE INDEX idx_transaction_occurred_at ON account_transactions (occurred_at);

INSERT INTO accounts(client_id, balance, account_limit) VALUES(1, 0, 100000);
INSERT INTO accounts(client_id, balance, account_limit) VALUES(2, 0, 80000);
INSERT INTO accounts(client_id, balance, account_limit) VALUES(3, 0, 1000000);
INSERT INTO accounts(client_id, balance, account_limit) VALUES(4, 0, 10000000);
INSERT INTO accounts(client_id, balance, account_limit) VALUES(5, 0, 500000);
