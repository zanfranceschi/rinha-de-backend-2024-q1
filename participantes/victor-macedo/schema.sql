CREATE TYPE transaction_type AS ENUM ('c', 'd');

CREATE TABLE IF NOT EXISTS clients(
    id SERIAL PRIMARY KEY NOT NULL,
    balance integer NOT NULL,
    client_limit integer NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL,
    client_id SMALLINT,
    transaction_date bigint,
    value integer,
    transaction_type transaction_type,
    description varchar(10),
    CONSTRAINT transactions_pk PRIMARY KEY (client_id, id),
    CONSTRAINT transactions_client_id_fkey FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE RESTRICT ON UPDATE CASCADE
) PARTITION BY LIST (client_id);

CREATE TABLE transactions_partition_1 PARTITION OF transactions FOR VALUES IN (1);
CREATE TABLE transactions_partition_2 PARTITION OF transactions FOR VALUES IN (2);
CREATE TABLE transactions_partition_3 PARTITION OF transactions FOR VALUES IN (3);
CREATE TABLE transactions_partition_4 PARTITION OF transactions FOR VALUES IN (4);
CREATE TABLE transactions_partition_5 PARTITION OF transactions FOR VALUES IN (5);

CREATE INDEX idx_transactions_composite
ON transactions (value, transaction_type, transaction_date DESC);

INSERT INTO clients (balance, client_limit)
VALUES 
(0, 100000),
(0, 80000),
(0, 1000000),
(0, 10000000),
(0, 500000);