CREATE UNLOGGED TABLE "customers" (
    "id"      SERIAL       NOT NULL PRIMARY KEY,
    "name"    VARCHAR(100) NOT NULL,
    "credit"  INTEGER      NOT NULL
);

CREATE UNLOGGED TABLE "transactions" (
    "id"          SERIAL       NOT NULL PRIMARY KEY,
    "customer_id" INTEGER      NOT NULL,
    "type"        CHARACTER(1) NOT NULL,
    "amount"      BIGINT       NOT NULL,
    "description" VARCHAR(10)  NOT NULL,
    "created_at"  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "balance"     BIGINT      NULL,
    CONSTRAINT "fk_clientes_transacoes_id"
            FOREIGN KEY ("customer_id") REFERENCES customers ("id")
);

CREATE INDEX created_at_balance_ix ON transactions (customer_id, created_at DESC, balance) WHERE balance is not null;

DO
$$
    BEGIN
        INSERT INTO customers (name, credit)
        VALUES ('mark zuguenbuerguerr', 1000 * 100),
               ('arnold schuzenega', 800 * 100),
               ('bill gata', 10000 * 100),
               ('ellon mockito', 100000 * 100),
               ('jack mau', 5000 * 100);
    END;
$$;
