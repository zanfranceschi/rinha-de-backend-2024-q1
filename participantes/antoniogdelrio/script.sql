CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  limite INT,
  saldo_inicial INT
);

CREATE TABLE transacoes (
  client_id INT,
  valor INT,
  tipo VARCHAR(1),
  descricao VARCHAR(10),
  data_transacao TIMESTAMPTZ,
  CONSTRAINT fk_client
      FOREIGN KEY(client_id) 
        REFERENCES clientes(id)
);

DO $$
BEGIN
  INSERT INTO clientes (limite, saldo_inicial)
  VALUES
    (1000 * 100, 0),
    (800 * 100, 0),
    (10000 * 100, 0),
    (100000 * 100, 0),
    (5000 * 100, 0);
END; $$