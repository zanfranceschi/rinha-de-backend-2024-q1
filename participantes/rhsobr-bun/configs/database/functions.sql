CREATE
OR REPLACE FUNCTION gera_extrato(cliente_id_p INTEGER) RETURNS JSON AS $$
DECLARE
    RESULT JSON;

BEGIN
    SELECT
        JSONB_BUILD_OBJECT(
            's',
            (
                SELECT
                    COALESCE(
                        JSONB_BUILD_OBJECT(
                            't',
                            cl.saldo,
                            'l',
                            cl.limite
                        ),
                        NULL :: JSONB
                    )
                FROM
                    clientes cl
                WHERE
                    cl.id = cliente_id_p
                LIMIT
                    1
            ), 'ut', (
                SELECT
                    COALESCE(JSONB_AGG(line), '[]' :: JSONB)
                FROM
                    (
                        SELECT
                            JSONB_BUILD_OBJECT(
                                'v',
                                t.valor,
                                't',
                                t.tipo,
                                'd',
                                t.descricao,
                                'r',
                                to_char (t.realizada_em, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"')
                            ) AS line
                        FROM
                            transacoes AS t
                        WHERE
                            t.cliente_id = cliente_id_p
                        ORDER BY
                            t.realizada_em DESC
                        LIMIT
                            10
                    ) AS _
            )
        ) INTO RESULT;

RETURN RESULT;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION inclui_transacao(
    cliente_id_p INTEGER,
    tipo_p CHAR,
    valor_p INTEGER,
    descricao_p VARCHAR
) RETURNS JSON AS $$
DECLARE
    RESULT JSON;

BEGIN
    WITH insertions AS (
        INSERT INTO
            transacoes (cliente_id, valor, tipo, descricao)
        SELECT
            id,
            valor_p,
            tipo_p,
            descricao_p
        FROM
            clientes cl
        WHERE
            cl.id = cliente_id_p
            AND (
                tipo_p = 'c'
                OR cl.saldo - valor_p >= cl.limite * -1
            )
        LIMIT
            1 FOR NO KEY
        UPDATE
            RETURNING cliente_id
    )
    UPDATE
        clientes cl
    SET
        saldo = saldo + (
            CASE
                WHEN tipo_p = 'd' THEN valor_p * -1
                ELSE valor_p
            END
        )
    FROM
        insertions ins
    WHERE
        cl.id = ins.cliente_id RETURNING COALESCE(
            JSONB_BUILD_OBJECT('saldo', saldo, 'limite', limite),
            NULL :: JSONB
        ) INTO RESULT;

RETURN RESULT;

END;

$$ LANGUAGE plpgsql;