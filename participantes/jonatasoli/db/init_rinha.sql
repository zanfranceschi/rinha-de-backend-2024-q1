CREATE TABLE clients (
  id SERIAL PRIMARY KEY,
  limite INT DEFAULT 0 NOT NULL,
  saldo INT DEFAULT 0 NOT NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  client_id SERIAL REFERENCES clients(id) NOT NULL,
  valor INT NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  tipo VARCHAR(1) NOT NULL,
  realizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX transactions_client_id_index ON transactions(client_id);
CREATE INDEX transactions_created_at_index ON transactions(realizado_em DESC);

INSERT INTO clients (limite, saldo) VALUES (100000, 0);
INSERT INTO clients (limite, saldo) VALUES (80000, 0);
INSERT INTO clients (limite, saldo) VALUES (1000000, 0);
INSERT INTO clients (limite, saldo) VALUES (10000000, 0);
INSERT INTO clients (limite, saldo) VALUES (500000, 0);
