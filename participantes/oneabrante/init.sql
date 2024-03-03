-- CreateTable
CREATE TABLE "cliente" (
    "id" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "limite" INTEGER NOT NULL,
    "saldo" INTEGER NOT NULL,

    CONSTRAINT "cliente_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transacao" (
    "id" TEXT NOT NULL,
    "valor" INTEGER NOT NULL,
    "tipo" TEXT NOT NULL,
    "descricao" TEXT NOT NULL,
    "realizada_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "clienteId" INTEGER NOT NULL,

    CONSTRAINT "transacao_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "transacao" ADD CONSTRAINT "transacao_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "cliente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- InsertData
INSERT INTO "cliente" ("id", "nome", "limite", "saldo") VALUES 
    (1, 'o barato sai caro', 1000 * 100, 0),
    (2, 'zan corp ltda', 800 * 100, 0),
    (3, 'les cruders', 10000 * 100, 0),
    (4, 'padaria joia de cocaia', 100000 * 100, 0),
    (5, 'kid mais', 5000 * 100, 0);
