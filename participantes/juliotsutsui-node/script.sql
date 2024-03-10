CREATE TABLE IF NOT EXISTS client (
  id SERIAL PRIMARY KEY,
  limite INT NOT NULL,
  saldo INT NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  client_id INT REFERENCES client(id),
  valor INT NOT NULL,
  tipo VARCHAR(1) NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO client (limite, saldo) 
VALUES 
  (100000, 0),
  (80000, 0),
  (1000000, 0),
  (10000000, 0),
  (500000, 0);