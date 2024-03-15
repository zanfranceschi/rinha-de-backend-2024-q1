CREATE EXTENSION IF NOT EXISTS plpgsql;

CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  credit_limit INTEGER NOT NULL DEFAULT 0,
  balance INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (balance >= -1 * credit_limit)
);

CREATE TABLE ledgers (
  id SERIAL PRIMARY KEY,
  amount INTEGER NOT NULL,
  kind CHAR(1) NOT NULL,
  description VARCHAR(10) NOT NULL,
  account_id INTEGER NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_accounts_ledgers_id
    FOREIGN KEY (account_id) REFERENCES accounts (id)
);

CREATE OR REPLACE FUNCTION update_balance_function()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
BEGIN
  IF TG_OP = 'INSERT' AND NEW.kind = 'c' THEN
    UPDATE accounts SET balance = balance + NEW.amount WHERE id = NEW.account_id;
  ELSIF TG_OP = 'INSERT' AND NEW.kind = 'd' THEN
    UPDATE accounts SET balance = balance - NEW.amount WHERE id = NEW.account_id;
  ELSIF TG_OP = 'DELETE' AND OLD.kind = 'c' THEN
    UPDATE accounts SET balance = balance - OLD.amount WHERE id = OLD.account_id;
  ELSIF TG_OP = 'DELETE' AND OLD.kind = 'd' THEN
    UPDATE accounts SET balance = balance + OLD.amount WHERE id = OLD.account_id;
  END IF;
  RETURN NULL;
END; $$;

CREATE TRIGGER update_balance
AFTER INSERT OR DELETE ON ledgers
FOR EACH ROW
EXECUTE FUNCTION update_balance_function();

DO $$
BEGIN
  INSERT INTO accounts (name, credit_limit)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$;
