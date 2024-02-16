SET CLIENT_MIN_MESSAGES = WARNING;
SET ROW_SECURITY = OFF;

CREATE UNLOGGED TABLE
    "clientes" (
        "id" INT PRIMARY KEY,
        "saldo" INTEGER NOT NULL,
        "limite" INTEGER NOT NULL
    );

CREATE INDEX idx_pk_clientes ON clientes (id) INCLUDE (saldo);
CLUSTER clientes USING idx_pk_clientes;

CREATE UNLOGGED TABLE
    "transacoes" (
        "id" SERIAL PRIMARY KEY,
        "valor" INTEGER NOT NULL,
        "id_cliente" INTEGER NOT NULL,
        "tipo" VARCHAR(1) NOT NULL,
        "descricao" VARCHAR(10) NOT NULL,
        "realizada_em" TIMESTAMP WITH TIME ZONE NOT NULL,
        CONSTRAINT "fk_transacoes_id_cliente" FOREIGN KEY ("id_cliente") REFERENCES "clientes" ("id")
    );

CREATE INDEX idx_transacoes_id_cliente ON transacoes (id_cliente);
CREATE INDEX idx_transacoes_realizada_em ON transacoes (realizada_em DESC);
CLUSTER transacoes USING idx_transacoes_id_cliente;


ALTER TABLE "clientes" SET (autovacuum_enabled = false);
ALTER TABLE "transacoes" SET (autovacuum_enabled = false);

INSERT INTO
    clientes (id, saldo, limite)
VALUES
    (1, 0, 100000),
    (2, 0, 80000),
    (3, 0, 1000000),
    (4, 0, 10000000),
    (5, 0, 500000);

CREATE OR REPLACE PROCEDURE criar_transacao_e_atualizar_saldo(
    id_cliente INTEGER,
    valor INTEGER,
    tipo VARCHAR(1),
    descricao VARCHAR(10),
    realizada_em TIMESTAMP WITH TIME ZONE,
    INOUT saldo_atual INTEGER DEFAULT NULL,
    INOUT limite_atual INTEGER DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    valor_absoluto INTEGER;
BEGIN
    valor_absoluto := valor;

    IF tipo = 'd' THEN
        valor := -valor;
    END IF;

    UPDATE clientes
    SET saldo = saldo + valor
    WHERE id = id_cliente AND (saldo + valor) >= -limite
    RETURNING saldo, limite INTO saldo_atual, limite_atual;

    INSERT INTO transacoes (valor, id_cliente, tipo, descricao, realizada_em)
    VALUES (valor_absoluto, id_cliente, tipo, descricao, realizada_em);
END;
$$;
