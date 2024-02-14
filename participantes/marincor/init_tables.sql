DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS transacoes;
DROP TYPE IF EXISTS "tipo_transacao";

CREATE TYPE "tipo_transacao" AS ENUM ('c', 'd');

CREATE TABLE IF NOT EXISTS clientes (
    "id" SERIAL NOT NULL,
    "saldo" INTEGER NOT NULL,
    "limite" INTEGER NOT NULL,
    CONSTRAINT "clientes_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS transacoes (
    "id" SERIAL NOT NULL,
    "valor" INTEGER NOT NULL,
    "id_cliente" INTEGER NOT NULL,
    "tipo" "tipo_transacao" NOT NULL,
    "descricao" VARCHAR(10) NOT NULL,
    "realizada_em" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transacoes_pkey PRIMARY KEY ("id"),
    CONSTRAINT fk_clientes_transacoes_id FOREIGN KEY ("id_cliente") REFERENCES clientes("id")
);

INSERT INTO
    clientes (saldo, limite)
VALUES
    (0, 1000 * 100),
    (0, 800 * 100),
    (0, 10000 * 100),
    (0, 100000 * 100),
    (0, 5000 * 100);