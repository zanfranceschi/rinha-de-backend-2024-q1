
CREATE TABLE account (
  id INTEGER PRIMARY KEY,
  saldo INTEGER NOT NULL,
  limite INTEGER NOT NULL
);
CREATE TABLE account_transaction (
  id SERIAL PRIMARY KEY,
  account_id INTEGER NOT NULL,
  valor INTEGER NOT NULL,
  tipo CHAR(1) NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY(account_id) REFERENCES account(id)
);

INSERT INTO account (id, limite, saldo) VALUES (1, 100000, 0);
INSERT INTO account (id, limite, saldo) VALUES (2, 80000, 0);
INSERT INTO account (id, limite, saldo) VALUES (3, 1000000, 0);
INSERT INTO account (id, limite, saldo) VALUES (4, 10000000, 0);
INSERT INTO account (id, limite, saldo) VALUES (5, 500000, 0);
