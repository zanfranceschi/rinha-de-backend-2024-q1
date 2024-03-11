CREATE TABLE if not EXISTS client (
    id SERIAL PRIMARY KEY ,
    currency_limit int NOT NULL,
    balance int NOT NULL,
    transactions int[]
);

INSERT INTO client (currency_limit, balance, transactions)
VALUES (100000, 0, array[]::int[]);

INSERT INTO client (currency_limit, balance, transactions)
VALUES (80000, 0, array[]::int[]);

INSERT INTO client (currency_limit, balance, transactions)
VALUES (80000, 0, array[]::int[]);

INSERT INTO client (currency_limit, balance, transactions)
VALUES (10000000, 0, array[]::int[]);

INSERT INTO client (currency_limit, balance, transactions)
VALUES (10000000, 0, array[]::int[]);
