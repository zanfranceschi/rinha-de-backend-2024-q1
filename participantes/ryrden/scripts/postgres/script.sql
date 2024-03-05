CREATE TABLE IF NOT EXISTS clients (
    id SERIAL PRIMARY KEY, 
    client_name text,
    balance_limit integer,
    balance integer DEFAULT 0
);

CREATE TYPE transaction_type AS ENUM('c', 'd');

CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL,
    client_id smallint,
    amount integer,
    kind transaction_type,
    description varchar(10),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transaction_client_id_fk FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE RESTRICT ON UPDATE CASCADE
) PARTITION BY LIST (client_id);

CREATE TABLE IF NOT EXISTS transactions_partition_1 PARTITION OF transactions FOR VALUES IN (1);
CREATE TABLE IF NOT EXISTS transactions_partition_2 PARTITION OF transactions FOR VALUES IN (2);
CREATE TABLE IF NOT EXISTS transactions_partition_3 PARTITION OF transactions FOR VALUES IN (3);
CREATE TABLE IF NOT EXISTS transactions_partition_4 PARTITION OF transactions FOR VALUES IN (4);
CREATE TABLE IF NOT EXISTS transactions_partition_5 PARTITION OF transactions FOR VALUES IN (5);


CREATE INDEX IF NOT EXISTS transactions_client_id_idx ON transactions(client_id);

CREATE INDEX idx_transactions_client_id_created_at_includes ON transactions (client_id, created_at DESC) INCLUDE (amount, kind, description);


INSERT INTO clients (client_name, balance_limit)
VALUES
('o barato sai caro', 1000 * 100),
('zan corp ltda', 800 * 100),
('les cruders', 10000 * 100),
('padaria joia de cocaia', 100000 * 100),
('kid mais', 5000 * 100);
