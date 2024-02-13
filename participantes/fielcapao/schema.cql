DROP KEYSPACE IF EXISTS rinha;

CREATE KEYSPACE IF NOT EXISTS rinha WITH REPLICATION = {'class':'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE IF NOT EXISTS rinha.accounts (
    id int,
    creditLimit int,
    balance int,
    PRIMARY KEY ( id )
);

INSERT INTO rinha.accounts(id, creditLimit, balance) VALUES (1, 100000, 0);
INSERT INTO rinha.accounts(id, creditLimit, balance) VALUES (2, 80000, 0);
INSERT INTO rinha.accounts(id, creditLimit, balance) VALUES (3, 1000000, 0);
INSERT INTO rinha.accounts(id, creditLimit, balance) VALUES (4, 10000000, 0);
INSERT INTO rinha.accounts(id, creditLimit, balance) VALUES (5, 500000, 0);

CREATE TABLE IF NOT EXISTS rinha.transactions (
    accountId int,
    type text,
    description text,
    date timestamp,
    amount int,
    PRIMARY KEY ((accountId), date )
) WITH CLUSTERING ORDER BY (date DESC);