CREATE TABLE IF NOT EXISTS statements(
    client_id BIGINT PRIMARY KEY,
    balance_limit BIGINT NOT NULL,
    current_balance BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions(
    client_id BIGINT NOT NULL,
    value BIGINT NOT NULL,
    type CHAR NOT NULL,
    description VARCHAR(10) NOT NULL,
    carried_out_at timestamp NOT NULL,
    PRIMARY KEY (client_id, carried_out_at)
);

CREATE INDEX transactions_carried_out_index ON transactions ( client_id, carried_out_at desc );

DO $$
BEGIN
INSERT INTO statements(client_id, balance_limit, current_balance)
VALUES
  (1, 100000, 0),
  (2, 80000, 0),
  (3, 1000000, 0),
  (4, 10000000, 0),
  (5, 500000, 0);
END;
$$
