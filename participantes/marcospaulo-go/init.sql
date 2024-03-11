CREATE UNLOGGED TABLE clientes
(
    id     INT PRIMARY KEY,
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
                limite_r integer,
                status_r integer
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
        return query select 0, 0, 1;
        --RAISE EXCEPTION 'Valor ultrapassa o limite+saldo';
    ELSE

        INSERT INTO transacoes (cliente_id, valor, tipo, descricao, realizada_em)
        VALUES (cliente_id_p, valor_p, 'd', descricao_p, now());

        novo_saldo := saldo_atual - valor_p;

        UPDATE clientes SET saldo = novo_saldo WHERE id = cliente_id_p;
    
        return query select novo_saldo, limite_atual, 0;

    END IF;

END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION limpar_transacoes()
    RETURNS trigger AS
$$
DECLARE
  row_count int;
BEGIN

    DELETE
    FROM transacoes
    WHERE cliente_id = NEW.cliente_id
      AND id NOT IN (SELECT id FROM transacoes WHERE cliente_id = NEW.cliente_id ORDER BY realizada_em DESC LIMIT 10);

    IF found THEN
        GET DIAGNOSTICS row_count = ROW_COUNT;
        RAISE NOTICE 'DELETED % row(s) FROM transacoes', row_count;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE TRIGGER trigger_delete_transacoes
    AFTER INSERT
    ON transacoes
    FOR EACH ROW
EXECUTE FUNCTION limpar_transacoes();


DO
$$
    BEGIN
        INSERT INTO clientes (id, limite)
        VALUES (1, 100000),
               (2, 80000),
               (3, 1000000),
               (4, 10000000),
               (5, 500000);
    END;
$$
