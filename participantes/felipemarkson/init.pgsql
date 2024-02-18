CREATE UNLOGGED TABLE clientes (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL CHECK(saldo >= -limite)
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

DO $$
BEGIN
    INSERT INTO clientes (limite, saldo)
    VALUES
        (1000   * 100, 0),
        (800    * 100, 0),
        (10000  * 100, 0),
        (100000 * 100, 0),
        (5000   * 100, 0);
END;
$$;


CREATE OR REPLACE FUNCTION push_credito(
    cliente_id_in INTEGER,
    valor_in INTEGER,
    descricao_in VARCHAR(10)
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE 
  ret json;
BEGIN
    WITH rw AS (
        UPDATE clientes SET saldo = saldo + valor_in
        WHERE id = cliente_id_in
        RETURNING limite, saldo
    ) SELECT to_json(rw) FROM rw INTO ret;

    IF NOT FOUND THEN RETURN NULL;
    END IF;

    INSERT INTO transacoes(cliente_id, valor, tipo, descricao)
    VALUES (cliente_id_in, valor_in, 'c' ,descricao_in);

    RETURN ret;
END
$$;

CREATE OR REPLACE FUNCTION push_debito(
    cliente_id_in int,
    valor_in int,
    descricao_in varchar(10)
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE 
  ret json;
BEGIN
    WITH rw AS (
        UPDATE clientes SET saldo = saldo - valor_in
        WHERE id = cliente_id_in
        RETURNING limite, saldo
    ) SELECT to_json(rw) FROM rw INTO ret;

    IF NOT FOUND THEN RETURN NULL;
    END IF;

    INSERT INTO transacoes(cliente_id, valor, tipo, descricao)
    VALUES (cliente_id_in, valor_in, 'd' ,descricao_in);
    
    RETURN ret;

EXCEPTION
    WHEN check_violation THEN RETURN NULL;
END
$$;


CREATE OR REPLACE FUNCTION get_extrato(
    cliente_id_in int
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE 
  ret json;
BEGIN
    SELECT json_build_object (
        'saldo', (
            SELECT to_json(sld) FROM (
                SELECT saldo AS total, LOCALTIMESTAMP AS data_extrato, limite
                FROM clientes WHERE clientes.id = cliente_id_in LIMIT 1
            ) sld
        ),
        'ultimas_transacoes',(
            SELECT coalesce(json_agg(tr), '[]'::json) FROM (
                SELECT valor, tipo, descricao, realizada_em FROM transacoes
                WHERE cliente_id = cliente_id_in ORDER BY realizada_em DESC LIMIT 10
            ) tr
        )
    ) INTO ret;
    IF NOT FOUND THEN
        ret := NULL;
    END IF;
    RETURN ret;
END
$$;