CREATE UNLOGGED TABLE accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(60) NOT NULL,
  account_limit INT,
  balance INT DEFAULT 0,
  CONSTRAINT non_negative_balance CHECK((account_limit + balance) >= 0)
);

CREATE TYPE operation_enum AS ENUM ('c', 'd');

CREATE UNLOGGED TABLE transactions (
  id SERIAL PRIMARY KEY,
  account_id INT,
  amount INT NOT NULL,
  operation operation_enum,
  description VARCHAR(10) NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_account
    FOREIGN KEY(account_id) 
      REFERENCES accounts(id)
);

DO $$
BEGIN
  INSERT INTO accounts (name, account_limit)
  VALUES
    ('one hundred years', 1000 * 100),
    ('between two lungs', 800 * 100),
    ('third eye', 10000 * 100),
    ('howl', 100000 * 100),
    ('all this and heaven too', 5000 * 100);
END; $$
