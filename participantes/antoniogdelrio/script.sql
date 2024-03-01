CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  limite INT,
  saldo INT
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
  INSERT INTO clientes (limite, saldo)
  VALUES
    (1000 * 100, 0),
    (800 * 100, 0),
    (10000 * 100, 0),
    (100000 * 100, 0),
    (5000 * 100, 0);
END; $$;

CREATE TYPE save_transaction_result AS (limite int, saldo int);

CREATE OR REPLACE FUNCTION save_transaction(IN client_id INT, IN valor INT, IN tipo CHAR(1), IN descricao VARCHAR(10)) RETURNS save_transaction_result
LANGUAGE plpgsql
AS $$
DECLARE
    l INT;
    s INT;
BEGIN
    SELECT limite, saldo INTO l, s FROM clientes WHERE id = client_id FOR UPDATE;

    IF tipo = 'd' AND (s - valor) >= l * -1 THEN
        UPDATE clientes SET saldo = s - valor WHERE id = client_id;
        s := s - valor;
    ELSIF tipo = 'c' THEN
        UPDATE clientes SET saldo = s + valor WHERE id = client_id;
        s := s + valor;
    ELSIF tipo = 'd' AND (s - valor) < l * -1 THEN
      RETURN NULL;
    END IF;

    INSERT INTO transacoes (client_id, valor, tipo, descricao, data_transacao) VALUES (client_id, valor, tipo, descricao, NOW());

    RETURN (l, s);
END $$;

CREATE INDEX idx_client ON transacoes (client_id ASC)