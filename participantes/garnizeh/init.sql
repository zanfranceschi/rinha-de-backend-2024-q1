CREATE UNLOGGED TABLE IF NOT EXISTS clients (
  id SERIAL PRIMARY KEY,
  client_limit INT,
  balance INT
);

CREATE UNLOGGED TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  client_id INT NOT NULL,
  CONSTRAINT fk_client_id FOREIGN KEY(client_id) REFERENCES clients(id),
  transaction_value INT,
  transaction_type VARCHAR(1),
  transaction_description VARCHAR(10),
  transaction_date TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tx_client_id ON transactions ("client_id");

DO $$
BEGIN
  INSERT INTO clients (id, client_limit, balance)
  VALUES
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);
END; $$