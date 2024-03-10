-- CreateEnum
CREATE TYPE "TipoTransacao" AS ENUM ('c', 'd');

-- CreateTable
CREATE TABLE "clientes" (
    "id_cliente" SERIAL NOT NULL,
    "nome" VARCHAR(256) NOT NULL,
    "limite" INTEGER NOT NULL,

    CONSTRAINT "clientes_pkey" PRIMARY KEY ("id_cliente")
);

-- CreateTable
CREATE TABLE "transacoes" (
    "id" SERIAL NOT NULL,
    "id_cliente" INTEGER NOT NULL,
    "valor" INTEGER NOT NULL,
    "tipo" "TipoTransacao" NOT NULL,
    "descricao" VARCHAR(10) NOT NULL,
    "realizada_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "transacoes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "saldos" (
    "id_cliente" INTEGER NOT NULL,
    "valor" INTEGER NOT NULL,

    CONSTRAINT "saldos_pkey" PRIMARY KEY ("id_cliente")
);

-- CreateIndex
CREATE UNIQUE INDEX "saldos_id_cliente_key" ON "saldos"("id_cliente");

-- AddForeignKey
ALTER TABLE "transacoes" ADD CONSTRAINT "transacoes_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "clientes"("id_cliente") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "saldos" ADD CONSTRAINT "saldos_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "clientes"("id_cliente") ON DELETE RESTRICT ON UPDATE CASCADE;

DO $$
BEGIN
	INSERT INTO clientes (nome, limite)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);
	
	INSERT INTO saldos (id_cliente, valor)
		SELECT id_cliente, 0 FROM clientes;
END;
$$;