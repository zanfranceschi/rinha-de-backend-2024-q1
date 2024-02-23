CREATE TABLE IF NOT EXISTS clientes
(
    id integer NOT NULL,
    nome varchar(50) NOT NULL,
    limite integer NOT NULL,
    saldo integer NOT NULL DEFAULT 0,
    ultimas_transacoes jsonb[] DEFAULT ARRAY[]::jsonb[],
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    CONSTRAINT clientes_pkey PRIMARY KEY (id),
    CONSTRAINT saldo_maior_que_o_limite CHECK (saldo >= (limite * '-1'::integer))
);

DO $$
BEGIN
  INSERT INTO clientes ("id", "nome", "limite", "inserted_at", "updated_at")
  VALUES
    (1, 'o barato sai caro', 1000 * 100, now(), now()),
    (2, 'zan corp ltda', 800 * 100, now(), now()),
    (3, 'les cruders', 10000 * 100, now(), now()),
    (4, 'padaria joia de cocaia', 100000 * 100, now(), now()),
    (5, 'kid mais', 5000 * 100, now(), now());
END; $$

