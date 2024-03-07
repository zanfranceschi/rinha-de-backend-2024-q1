CREATE TABLE IF NOT EXISTS clientes (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(10),
  saldo INT DEFAULT 0,
  limite INT
);

CREATE TABLE IF NOT EXISTS transacoes (
  id SERIAL PRIMARY KEY,
  cliente_id INT,
  valor INT,
  tipo VARCHAR(1),
  descricao VARCHAR(10),
  realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_cliente
    FOREIGN KEY(cliente_id) REFERENCES clientes(id)
);

ALTER TABLE clientes
ADD CONSTRAINT checar_saldo
CHECK (saldo >= -limite);

CREATE OR REPLACE FUNCTION checar_limite_saldo()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS(
    SELECT 1 FROM clientes WHERE id = NEW.cliente_id AND (saldo - NEW.valor) < -limite
  ) THEN
    RAISE EXCEPTION 'Transação Inválida: Saldo negativo não pode ser menor do que seu limite.';
  END IF;
  RETURN NEW;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER before_transaction_insert
BEFORE INSERT ON transacoes
FOR EACH ROW
EXECUTE FUNCTION checar_limite_saldo();

DO $$

BEGIN
  INSERT INTO clientes (nome, limite)
  VALUES
    ('Cliente 1', 100000),
    ('Cliente 2', 80000),
    ('Cliente 3', 1000000),
    ('Cliente 4', 10000000),
    ('Cliente 5', 500000);
END; $$
