-- DROP TABLE IF EXISTS
DROP TABLE IF EXISTS "transacoes";

DROP TABLE IF EXISTS "clientes";

-- CreateTable
CREATE TABLE "clientes" (
  "id" SERIAL NOT NULL,
  "nome" VARCHAR(255) NOT NULL,
  "limite" INTEGER NOT NULL,
  "saldo" INTEGER NOT NULL DEFAULT 0,
  CONSTRAINT "clientes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transacoes" (
  "id" SERIAL NOT NULL,
  "valor" INTEGER NOT NULL,
  "tipo" CHAR(1) NOT NULL,
  "descricao" TEXT,
  "realizada_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "cliente_id" INTEGER,
  CONSTRAINT "transacoes_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE
  "transacoes"
ADD
  CONSTRAINT "transacoes_cliente_id_fkey" FOREIGN KEY ("cliente_id") REFERENCES "clientes"("id") ON DELETE
SET
  NULL ON UPDATE CASCADE;

INSERT INTO
  clientes (id, nome, limite, saldo)
VALUES
  (1, 'o barato sai caro', 100000, 0),
  (2, 'zan corp ltda', 80000, 0),
  (3, 'les cruders', 1000000, 0),
  (4, 'padaria joia de cocaia', 10000000, 0),
  (5, 'kid mais', 500000, 0);