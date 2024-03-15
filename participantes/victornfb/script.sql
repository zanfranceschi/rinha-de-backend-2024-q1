DROP TABLE IF EXISTS Transaction;

DROP TABLE IF EXISTS Account;

CREATE TABLE Account (
  id SERIAL PRIMARY KEY,
  limite INTEGER NOT NULL DEFAULT 0,
  saldo INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE Transaction (
  id SERIAL PRIMARY KEY,
  account_id INTEGER REFERENCES Account(id),
  valor INTEGER NOT NULL,
  tipo CHAR(1) NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_transaction_accountId_createdAt ON Transaction (account_id, realizada_em DESC);

INSERT INTO Account (id, limite)
VALUES
  (1, 100000),
  (2, 80000),
  (3, 1000000),
  (4, 10000000),
  (5, 500000);