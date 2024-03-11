CREATE TABLE if not exists customers(
  id SERIAL PRIMARY KEY,
  nome varchar(50) NOT NULL,
  limite INTEGER NOT NULL,
  saldo INTEGER NOT NULL
);

CREATE TABLE if not exists transactions(
  id SERIAL PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  valor INTEGER NOT NULL,
  tipo varchar(1) NOT NULL,
  descricao varchar (10) NOT NULL,
  realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_customers_transactions_id 
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO customers (nome, limite, saldo)
VALUES
  ('o barato sai caro', 1000 * 100, 0),
  ('zan corp ltda', 800 * 100, 0),
  ('les cruders', 10000 * 100, 0),
  ('padaria joia de cocaia', 100000 * 100, 0),
  ('kid mais', 5000 * 100, 0);