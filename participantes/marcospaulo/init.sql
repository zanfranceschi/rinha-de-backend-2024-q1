CREATE UNLOGGED TABLE clientes
(
    id     INT PRIMARY KEY,
    nome   VARCHAR(50),
    limite INTEGER NOT NULL,
    saldo  INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transacoes
(
    id           SERIAL PRIMARY KEY,
    cliente_id   INTEGER     NOT NULL,
    valor        INTEGER     NOT NULL,
    tipo         CHAR(1)     NOT NULL,
    descricao    VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP   NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_transacoes_clientes_id
        FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);

CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id);

CREATE INDEX idx_transacoes_cliente_id_realizada_em ON transacoes (cliente_id, realizada_em desc);

CREATE INDEX idx_transacoes_realizada_em ON transacoes (realizada_em desc);


CREATE OR REPLACE FUNCTION creditar(cliente_id_p int, valor_p integer, descricao_p varchar(10))
    RETURNS TABLE
            (
                saldo_r  integer,
                limite_r integer
            )
AS
$$
DECLARE
    saldo_atual  INTEGER;
    limite_atual INTEGER;
    novo_saldo   INTEGER;
BEGIN

    PERFORM pg_advisory_xact_lock(cliente_id_p);

    SELECT saldo, limite INTO saldo_atual, limite_atual FROM clientes WHERE id = cliente_id_p;

    INSERT INTO transacoes (cliente_id, valor, tipo, descricao, realizada_em)
    VALUES (cliente_id_p, valor_p, 'c', descricao_p, now());

    novo_saldo := saldo_atual + valor_p;

    UPDATE clientes SET saldo = novo_saldo WHERE id = cliente_id_p;

    return query select novo_saldo, limite_atual;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION debitar(cliente_id_p int, valor_p integer, descricao_p varchar(10))
    RETURNS TABLE
            (
                saldo_r  integer,
                limite_r integer
            )
AS
$$
DECLARE
    saldo_atual  INTEGER;
    limite_atual INTEGER;
    novo_saldo   INTEGER;
BEGIN


    PERFORM pg_advisory_xact_lock(cliente_id_p);

    SELECT limite, saldo INTO limite_atual, saldo_atual FROM clientes WHERE id = cliente_id_p;

    IF (saldo_atual - valor_p < limite_atual * -1) THEN
        RAISE EXCEPTION 'Valor ultrapassa o limite+saldo';
    END IF;


    INSERT INTO transacoes (cliente_id, valor, tipo, descricao, realizada_em)
    VALUES (cliente_id_p, valor_p, 'd', descricao_p, now());

    novo_saldo := saldo_atual - valor_p;

    UPDATE clientes SET saldo = novo_saldo WHERE id = cliente_id_p;

    return query select novo_saldo, limite_atual;

END;
$$ LANGUAGE plpgsql;


DO
$$
    BEGIN
        INSERT INTO clientes (id, nome, limite)
        VALUES (1, 'Pilot', 100000),
               (2, 'Paternity', 80000),
               (3, 'Occam''s Razor', 1000000),
               (4, 'Maternity', 10000000),
               (5, 'Damned If You Do', 500000);
    END;
$$