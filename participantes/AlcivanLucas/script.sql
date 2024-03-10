-- CreateTable
-- CreateTable
CREATE TABLE "clientes" (
    "id" SERIAL NOT NULL,
    "limite" INTEGER NOT NULL,
    "saldo" INTEGER NOT NULL,

    CONSTRAINT "clientes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transacoes" (
    "id" SERIAL NOT NULL,
    "cliente_id" INTEGER NOT NULL,
    "valor" INTEGER NOT NULL,
    "tipo" TEXT NOT NULL,
    "descricao" TEXT NOT NULL,
    "realizada_em" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "transacoes_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "transacoes_cliente_id_fkey" FOREIGN KEY ("cliente_id") REFERENCES "clientes" ("id")
);

INSERT INTO
  "clientes" ("limite","saldo")
VALUES
  (100000, 0),
  (80000, 0),
  (1000000, 0),
  (10000000, 0),
  (500000, 0);

-- CREATE TABLE "clientes" (
--     "id" SERIAL NOT NULL,
--     "limite" INTEGER NOT NULL,
--     "saldo" INTEGER NOT NULL,

--     CONSTRAINT "clientes_pkey" PRIMARY KEY ("id")
-- );

-- -- CreateTable
-- CREATE TABLE "transacoes" (
--     "id" SERIAL NOT NULL,
--     "cliente_id" INTEGER NOT NULL,
--     "valor" INTEGER NOT NULL,
--     "tipo" TEXT NOT NULL,
--     "descricao" TEXT NOT NULL,
--     "realizada_em" TIMESTAMP(3) NOT NULL,

--     CONSTRAINT "transacoes_pkey" PRIMARY KEY ("id")
-- );
