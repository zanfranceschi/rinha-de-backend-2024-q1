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

    CONSTRAINT "transacoes_pkey" PRIMARY KEY ("id")
);
