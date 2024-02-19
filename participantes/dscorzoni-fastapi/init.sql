CREATE UNLOGGED TABLE "customers" (
    "id"      SERIAL       NOT NULL PRIMARY KEY,
    "limite"  INTEGER      NOT NULL,
    "saldo" BIGINT       NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE "transactions" (
    "id"          SERIAL       NOT NULL PRIMARY KEY,
    "customer_id" INTEGER      NOT NULL,
    "tipo"        CHARACTER(1) NOT NULL,
    "valor"       BIGINT       NOT NULL,
    "descricao" VARCHAR(10)  NOT NULL,
    "realizada_em"  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "fk_clientes_transacoes_id"
        FOREIGN KEY ("customer_id") REFERENCES customers ("id")
);

CREATE INDEX "fk_transactions_customer_id" ON "public"."transactions" ("customer_id");

DO
$$
    BEGIN
        INSERT INTO customers (limite, saldo)
        VALUES (1000 * 100, 0),
               (800 * 100, 0),
               (10000 * 100, 0),
               (100000 * 100, 0),
               (5000 * 100, 0);
    END;
$$;