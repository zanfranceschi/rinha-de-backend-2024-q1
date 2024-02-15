CREATE TYPE "tipo_transacao" AS ENUM ('c', 'd');

CREATE TABLE
    "clientes" (
        "id" SERIAL NOT NULL,
        "saldo" INTEGER NOT NULL,
        "limite" INTEGER NOT NULL,
        CONSTRAINT "clientes_pkey" PRIMARY KEY ("id")
    );

CREATE TABLE
    "transacoes" (
        "id" SERIAL NOT NULL,
        "valor" INTEGER NOT NULL,
        "id_cliente" INTEGER NOT NULL,
        "tipo" "tipo_transacao" NOT NULL,
        "descricao" VARCHAR(10) NOT NULL,
        "realizada_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT "transacoes_pkey" PRIMARY KEY ("id")
    );

ALTER TABLE "transacoes" ADD CONSTRAINT "transacoes_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "clientes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

CREATE INDEX transacoes_ordering ON transacoes (realizada_em DESC, id_cliente);

INSERT INTO
    clientes (saldo, limite)
VALUES
    (0, 1000 * 100),
    (0, 800 * 100),
    (0, 10000 * 100),
    (0, 100000 * 100),
    (0, 5000 * 100);