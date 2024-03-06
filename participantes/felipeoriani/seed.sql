DO $$
BEGIN
  TRUNCATE TABLE transacoes;
  TRUNCATE TABLE clientes;
  INSERT INTO clientes (id) VALUES (1), (2), (3), (4), (5);
END;
$$;
