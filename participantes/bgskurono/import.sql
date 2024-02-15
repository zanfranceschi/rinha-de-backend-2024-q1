CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nome VARCHAR (50) NOT NULL,
  limite INTEGER NOT NULL
);

CREATE TABLE carteiras (
   id SERIAL PRIMARY KEY,
   cliente_id INTEGER NOT NULL,
   valor INTEGER NOT NULL,
   ultimas_transacoes json[] NULL
);

DO $$
BEGIN
INSERT INTO clientes (nome, limite)
VALUES
    ('cliente 1', 1000 * 100),
    ('cliente 2', 800 * 100),
    ('cliente 3', 10000 * 100),
    ('cliente 4', 100000 * 100),
    ('cliente 5', 5000 * 100);
INSERT INTO carteiras(cliente_id, valor)
SELECT id, 0 FROM clientes;
END;
$$;
