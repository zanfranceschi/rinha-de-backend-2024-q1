CREATE TABLE IF NOT EXISTS clientes (
			id SERIAL PRIMARY KEY,
			limite INT,
			saldo INT DEFAULT 0
		);

CREATE TABLE IF NOT EXISTS transacoes (
			id SERIAL PRIMARY KEY,
			valor INT,
			tipo CHAR(1),
			descricao VARCHAR(10),
			realizada_em TIMESTAMP,
			id_cliente INT
		);

DO $$
BEGIN
  IF NOT EXISTS (SELECT * FROM clientes WHERE id BETWEEN 1 AND 5) THEN
    INSERT INTO clientes (limite) 
			VALUES 
			(1000 * 100),
			(800 * 100),
			(10000 * 100),
			(100000 * 100),
			(5000 * 100);
  END IF;
END;
$$;