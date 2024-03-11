CREATE UNLOGGED TABLE accounts (
	id INTEGER NOT NULL,
	name CHAR(1) NOT NULL,
	limit_amount INTEGER NOT NULL,
	balance INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transactions (
	account_id INTEGER NOT NULL,
	value INTEGER NOT NULL,
	type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	date TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_cov_accounts ON accounts(id) INCLUDE (limit_amount, balance);
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_account_date ON transactions(date);

INSERT INTO accounts (id, name, limit_amount, balance)
VALUES
  (1, 'a', 100000, 0),
  (2, 'b', 80000, 0),
  (3, 'c', 1000000, 0),
  (4, 'd', 10000000, 0),
  (5, 'e', 500000, 0);
