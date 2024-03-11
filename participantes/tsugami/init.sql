-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM('c', 'd');

-- CreateTable
CREATE TABLE "accounts" (
    "id" SERIAL NOT NULL PRIMARY KEY,

    "saldo" BIGINT NOT NULL,
    "limite" BIGINT NOT NULL
);

ALTER TABLE "accounts" ADD CONSTRAINT "accounts_saldo_limit" CHECK ("saldo" >= ~"limite");

-- CreateTable
CREATE TABLE "transactions" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "valor" BIGINT NOT NULL,
    "tipo" "TransactionType" NOT NULL,
    "realizada_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "account_id" INTEGER NOT NULL,
    "descricao" TEXT
);

-- AddForeignKey
ALTER TABLE "transactions"
ADD CONSTRAINT "transactions_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

DO $$
BEGIN
	INSERT INTO accounts (id, limite, saldo)
	VALUES
		(1, 1000 * 100, 0),
		(2, 800 * 100, 0),
		(3, 10000 * 100, 0),
		(4, 100000 * 100, 0),
		(5, 5000 * 100, 0);
END;
$$;
