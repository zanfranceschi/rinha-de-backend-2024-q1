CREATE TABLE IF NOT EXISTS clientes
(
    id integer NOT NULL,
    nome varchar(50) NOT NULL,
    limite integer NOT NULL,
    saldo integer NOT NULL DEFAULT 0,
    ultimas_transacoes jsonb[] DEFAULT ARRAY[]::jsonb[],
    CONSTRAINT clientes_pkey PRIMARY KEY (id)
);

DO $$
BEGIN
  INSERT INTO clientes ("id", "nome", "limite")
  VALUES
    (1, 'o barato sai caro', 1000 * 100),
    (2, 'zan corp ltda', 800 * 100),
    (3, 'les cruders', 10000 * 100),
    (4, 'padaria joia de cocaia', 100000 * 100),
    (5, 'kid mais', 5000 * 100);
END; $$
