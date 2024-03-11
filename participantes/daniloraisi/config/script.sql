CREATE UNLOGGED TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    limite INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    data_transacao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_clientes_transacoes_id
        FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

CREATE UNLOGGED TABLE saldos (
    id SERIAL NOT NULL,
    id_cliente INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    CONSTRAINT fk_clientes_saldos_id
        FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    PRIMARY KEY (id, id_cliente)
);

DO $$
BEGIN
    INSERT INTO clientes (nome, limite)
    VALUES
        ('Ivo Matias', 1000 * 100),
        ('Electra Costa', 800 * 100),
        ('Pilar Nascimento', 10000 * 100),
        ('Carmelina Vaz', 100000 * 100),
        ('Marco Vilar', 5000 * 100);

    INSERT INTO saldos (id_cliente, valor)
        SELECT id, 0 FROM clientes;
END;
$$;

CREATE OR REPLACE FUNCTION debito (
    id_cliente_tx INT,
    valor_tx INT,
    descricao_tx VARCHAR(10)
)
RETURNS TABLE (
    novo_saldo INT,
    limite INT,
    com_erro BOOL,
    mensagem VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
DECLARE
    saldo_atual INT;
    limite_atual INT;
BEGIN
    PERFORM pg_advisory_xact_lock(id_cliente_tx);
    SELECT
        c.limite,
        COALESCE(s.valor, 0)
    INTO
        limite_atual,
        saldo_atual
    FROM
        clientes c
        LEFT JOIN saldos s
            ON c.id = s.id_cliente
    WHERE
        c.id = id_cliente_tx;

    IF saldo_atual - valor_tx >= limite_atual * -1 THEN
        INSERT INTO transacoes
        VALUES
            (DEFAULT, id_cliente_tx, valor_tx, 'd', descricao_tx, NOW());

        UPDATE saldos
        SET
            valor = valor - valor_tx
        WHERE
            id_cliente = id_cliente_tx;

        RETURN QUERY
            SELECT
                valor,
                limite_atual,
                FALSE,
                'OK'::VARCHAR(20)
            FROM
                saldos
            WHERE
                id_cliente = id_cliente_tx;
    ELSE
        RETURN QUERY
            SELECT
                valor,
                limite_atual,
                TRUE,
                'saldo insuficiente'::VARCHAR(20)
            FROM
                saldos
            WHERE
                id_cliente = id_cliente_tx;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION credito (
    id_cliente_tx INT,
    valor_tx INT,
    descricao_tx VARCHAR(20)
)
RETURNS TABLE (
    novo_saldo INT,
    limite INT,
    com_erro BOOL,
    mensagem VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
DECLARE
    limite_atual INT;
BEGIN
    PERFORM pg_advisory_xact_lock(id_cliente_tx);

    SELECT c.limite
    INTO limite_atual
    FROM clientes c
    WHERE
        c.id = id_cliente_tx;
        
    INSERT INTO transacoes
    VALUES
        (DEFAULT, id_cliente_tx, valor_tx, 'c', descricao_tx, NOW());

    RETURN QUERY
        UPDATE saldos
        SET
            valor = valor + valor_tx
        WHERE
            saldos.id_cliente = id_cliente_tx
        RETURNING
            valor, limite_atual, FALSE, 'OK'::VARCHAR(20);
END;
$$;

CREATE OR REPLACE FUNCTION reset_db ()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE saldos
    SET
        valor = 0;

    TRUNCATE TABLE transacoes;
END;
$$;

CREATE OR REPLACE FUNCTION public.extrato(
	id_cliente_tx INT
)
RETURNS TABLE(
    extrato jsonb
)
LANGUAGE SQL
AS $$
SELECT
	json_build_object(
		'valor', tx.valor,
		'tipo', tx.tipo,
		'descricao', tx.descricao,
		'realizada_em', tx.data_transacao
	)
FROM
	transacoes tx
WHERE
	tx.id_cliente = id_cliente_tx
ORDER BY tx.id DESC
LIMIT 10;
$$;

