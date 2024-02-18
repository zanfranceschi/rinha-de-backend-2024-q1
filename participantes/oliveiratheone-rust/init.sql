CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE UNLOGGED TABLE
    "clientes" (
                   "id" SERIAL NOT NULL,
                   "saldo" INTEGER NOT NULL,
                   "limite" INTEGER NOT NULL,
                   CONSTRAINT "clientes_pkey" PRIMARY KEY ("id")
);

CREATE UNLOGGED TABLE
    "transacoes" (
                     "id" SERIAL NOT NULL,
                     "valor" INTEGER NOT NULL,
                     "id_cliente" INTEGER NOT NULL,
                     "tipo" char(1) NOT NULL,
                     "descricao" VARCHAR(10) NOT NULL,
                     "realizada_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
                     CONSTRAINT "transacoes_pkey" PRIMARY KEY ("id")
);

CREATE INDEX transacoes_ordering ON transacoes (realizada_em DESC, id_cliente);
CREATE INDEX idx_clientes_id ON clientes (id);
CREATE INDEX idx_clientes_limite ON clientes (limite);

INSERT INTO
    clientes (saldo, limite)
VALUES
    (0, 1000 * 100),
    (0, 800 * 100),
    (0, 10000 * 100),
    (0, 100000 * 100),
    (0, 5000 * 100);
