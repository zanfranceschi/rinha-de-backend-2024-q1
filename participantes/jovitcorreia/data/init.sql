DROP TABLE IF EXISTS transacao;
DROP TABLE IF EXISTS cliente;

CREATE UNLOGGED TABLE cliente (
    id     SMALLSERIAL PRIMARY KEY,
    limite INT NOT NULL,
    saldo  BIGINT NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transacao (
   id           SERIAL PRIMARY KEY,
   cliente_id   SMALLINT NOT NULL,
   valor        BIGINT NOT NULL,
   tipo         CHAR(1) NOT NULL,
   descricao    TEXT NOT NULL,
   realizada_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()::timestamp,
   CONSTRAINT fk_transacao_cliente FOREIGN KEY (cliente_id) REFERENCES cliente (id)
);

CREATE INDEX ON transacao (cliente_id, realizada_em DESC);

CREATE OR REPLACE FUNCTION public.get_stmt(c INT)
    RETURNS JSON AS
$$
DECLARE
    holder JSON;
    tnxs   JSON;
BEGIN
    SELECT json_build_object(
        'total', saldo,
        'data_extrato', to_char(now() AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"'),
        'limite', limite
    )
    INTO holder
    FROM cliente
    WHERE id = c;

    SELECT json_agg(
       json_build_object(
           'valor', valor,
           'tipo', tipo,
           'descricao', descricao,
           'realizada_em', to_char(realizada_em AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"')
       )
    ) INTO tnxs
    FROM (
        SELECT valor, tipo, descricao, realizada_em
        FROM transacao
        WHERE cliente_id = c
        ORDER BY realizada_em DESC
        LIMIT 10
    ) AS t;

    RETURN json_build_object('saldo', holder, 'ultimas_transacoes', COALESCE(tnxs, '[]'::json));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.set_txn(
    c INT,
    d TEXT,
    t TEXT,
    v BIGINT
) RETURNS JSON AS
$$
DECLARE
    s BIGINT;
    n BIGINT;
    l INT;
BEGIN
    SELECT saldo INTO s FROM cliente WHERE id = c FOR UPDATE;
    SELECT limite INTO l FROM cliente WHERE id = c;

    IF t = 'c' THEN
        n := s + v;
    ELSE
        n := s - v;
    END IF;

    IF n >= -l THEN
        UPDATE cliente SET saldo = n WHERE id = c;
        INSERT INTO transacao(cliente_id, valor, tipo, descricao) VALUES (c, v, t, d);
        RETURN json_build_object('limite', l, 'saldo', n);
    END IF;
END;
$$ LANGUAGE plpgsql;

DO
$$
    BEGIN
        INSERT INTO cliente (limite)
        VALUES (100000), (80000), (1000000), (10000000), (500000);
    END;
$$;
