-- Add migration script here

CREATE TABLE clients (
  id SERIAL PRIMARY KEY,
  balance_limit INT DEFAULT 0 NOT NULL,
  balance INT DEFAULT 0 NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  client_id SERIAL REFERENCES clients(id) NOT NULL,
  amount INT NOT NULL,
  description VARCHAR(10) NOT NULL,
  type VARCHAR(1) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX transactions_client_id_index ON transactions(client_id);
CREATE INDEX transactions_created_at_index ON transactions(created_at DESC);

INSERT INTO clients (balance_limit, balance) VALUES (100000, 0);
INSERT INTO clients (balance_limit, balance) VALUES (80000, 0);
INSERT INTO clients (balance_limit, balance) VALUES (1000000, 0);
INSERT INTO clients (balance_limit, balance) VALUES (10000000, 0);
INSERT INTO clients (balance_limit, balance) VALUES (500000, 0);
