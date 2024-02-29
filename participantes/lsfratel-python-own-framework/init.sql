CREATE UNLOGGED TABLE "customers" (
    "id"      SERIAL       NOT NULL PRIMARY KEY,
    "name"    VARCHAR(100) NOT NULL,
    "credit"  INTEGER      NOT NULL,
    "balance" BIGINT       NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE "transactions" (
    "id"          SERIAL       NOT NULL PRIMARY KEY,
    "customer_id" INTEGER      NOT NULL,
    "type"        CHARACTER(1) NOT NULL,
    "amount"      BIGINT       NOT NULL,
    "description" VARCHAR(10)  NOT NULL,
    "created_at"  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "fk_clientes_transacoes_id"
        FOREIGN KEY ("customer_id") REFERENCES customers ("id")
);

CREATE INDEX "fk_transactions_customer_id" ON "public"."transactions" ("customer_id");

DO
$$
    BEGIN
        INSERT INTO customers (name, credit, balance)
        VALUES ('mark zuguenbuerguerr', 1000 * 100, 0),
               ('arnold schuzenega', 800 * 100, 0),
               ('bill gata', 10000 * 100, 0),
               ('ellon mockito', 100000 * 100, 0),
               ('jack mau', 5000 * 100, 0);
    END;
$$;
