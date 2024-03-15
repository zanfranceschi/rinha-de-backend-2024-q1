CREATE UNLOGGED TABLE accounts(
  id SERIAL PRIMARY KEY,
  limit_amount INT NOT NULL,
  balance INT NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transactions(
  id SERIAL PRIMARY KEY,
  amount INT NOT NULL,
  description VARCHAR(100) NOT NULL,
  type VARCHAR(1) NOT NULL,
  account_id INT NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  CONSTRAINT fk_account_id FOREIGN KEY (account_id) REFERENCES accounts(id)
);

CREATE INDEX idx_transactions_account_id ON transactions
(
    account_id ASC
);

DELETE FROM transactions;
DELETE FROM accounts;

DO $$
BEGIN
	INSERT INTO accounts (limit_amount, balance)
	VALUES
		(1000 * 100, 0),
		(800 * 100, 0),
		(10000 * 100, 0),
		(100000 * 100, 0),
		(5000 * 100, 0);
END;
$$;
