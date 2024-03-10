CREATE TABLE IF NOT EXISTS clients (
  id INTEGER PRIMARY KEY,
  balance INTEGER NOT NULL DEFAULT 0,
  name VARCHAR(50) NOT NULL,
  account_limit INTEGER NOT NULL,
  CONSTRAINT balance_limit CHECK (balance >= account_limit * -1)
);

CREATE TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  client_id INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  type CHAR(1) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  description VARCHAR(10) NOT NULL,
  FOREIGN KEY (client_id) REFERENCES clients(id)
);

INSERT INTO clients (id, name, account_limit) VALUES
(1, 'o barato sai caro', 1000 * 100),
(2, 'zan corp ltda', 800 * 100),
(3, 'les cruders', 10000 * 100),
(4, 'padaria joia de cocaia', 100000 * 100),
(5, 'kid mais', 5000 * 100);