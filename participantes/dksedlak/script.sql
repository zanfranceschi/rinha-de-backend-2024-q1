CREATE TABLE IF NOT EXISTS accounts(
    id INTEGER NOT NULL,
    credit_limit BIGINT NOT NULL,
    balance BIGINT NOT NULL,
    last_transactions JSON[] NOT NULL,
    CONSTRAINT pk_balance PRIMARY KEY(id),
    CONSTRAINT check_balance_limit CHECK (credit_limit + balance >= 0)
);

INSERT INTO accounts(id, credit_limit, balance, last_transactions) VALUES(1,   100000, 0, ARRAY[]::JSON[]);
INSERT INTO accounts(id, credit_limit, balance, last_transactions) VALUES(2,    80000, 0, ARRAY[]::JSON[]);
INSERT INTO accounts(id, credit_limit, balance, last_transactions) VALUES(3,  1000000, 0, ARRAY[]::JSON[]);
INSERT INTO accounts(id, credit_limit, balance, last_transactions) VALUES(4, 10000000, 0, ARRAY[]::JSON[]);
INSERT INTO accounts(id, credit_limit, balance, last_transactions) VALUES(5,   500000, 0, ARRAY[]::JSON[]);