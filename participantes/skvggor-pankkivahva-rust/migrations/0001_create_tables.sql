CREATE UNLOGGED TABLE IF NOT EXISTS clientes (
  id SERIAL PRIMARY KEY,
  limite INTEGER NOT NULL,
  saldo INTEGER NOT NULL
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (
  id SERIAL PRIMARY KEY,
  id_cliente INTEGER NOT NULL,
  valor INTEGER NOT NULL,
  tipo CHAR(1) NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  realizada_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

  FOREIGN KEY (id_cliente) REFERENCES clientes (id)
);

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM clientes WHERE id = 1) THEN
    INSERT INTO clientes (limite, saldo)
    VALUES
      (100000, 0),
      (80000, 0),
      (1000000, 0),
      (10000000, 0),
      (500000, 0);
  END IF;
END $$;
