CREATE TABLE
    "Clientes" (
        "Id" SERIAL NOT NULL PRIMARY KEY,
        "SaldoInicial" INTEGER NOT NULL DEFAULT 0,
        "Limite" INTEGER NOT NULL
    );

CREATE TABLE
    "Transacoes" (
        "Id" SERIAL NOT NULL PRIMARY KEY,
        "Valor" INTEGER NOT NULL,
        "ClienteId" INTEGER NOT NULL,
        "Tipo" VARCHAR(1) NOT NULL,
        "Descricao" VARCHAR(10) NOT NULL,
        "Data" TIMESTAMP NOT NULL DEFAULT NOW()
    );

ALTER TABLE "Transacoes" ADD CONSTRAINT "transacoes_clienteid_fkey" FOREIGN KEY ("ClienteId") REFERENCES "Clientes" ("Id") ON DELETE RESTRICT ON UPDATE CASCADE;

CREATE INDEX "idx_id_cliente"
ON "Clientes" ("Id");

DO $$
BEGIN
  INSERT INTO "Clientes" ("Limite")
  VALUES
    (1000 * 100),
    (800 * 100),
    (10000 * 100),
    (100000 * 100),
    (5000 * 100);
END; $$