CREATE UNLOGGED TABLE client(
  id SERIAL PRIMARY KEY,
  account_limit INTEGER NOT NULL,
  account_balance INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transaction(
  id VARCHAR(255) PRIMARY KEY,
  operation_value INTEGER NOT NULL,
  operation_type CHAR(1) NOT NULL,
  operation_description VARCHAR(10) NOT NULL, 
  client_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT current_timestamp
);

INSERT INTO client (id, account_limit, account_balance) VALUES
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);

CREATE INDEX ix_transaction_client_id ON transaction(client_id);