CREATE UNLOGGED TABLE clientes (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE UNLOGGED TABLE saldos (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    valor INTEGER NOT NULL
);

DO $$
BEGIN
    INSERT INTO clientes (limite)
    VALUES
        (1000 * 100),
        (800 * 100),
        (10000 * 100),
        (100000 * 100),
        (5000 * 100);

    INSERT INTO saldos (cliente_id, valor)
        SELECT id, 0 FROM clientes;
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
    UPDATE saldos SET valor = valor + valor_in WHERE cliente_id = cliente_id_in;
    IF NOT FOUND THEN
        ret := NULL;
        RETURN ret;
    END IF;

    INSERT INTO transacoes(cliente_id, valor, tipo, descricao)
        VALUES (cliente_id_in, valor_in, 'c' ,descricao_in);

    SELECT to_json(rw) FROM (
        SELECT limite, saldos.valor as saldo
            FROM clientes
                INNER JOIN saldos ON clientes.id = saldos.cliente_id
            WHERE clientes.id = cliente_id_in
            LIMIT 1
    ) rw
        INTO ret;

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
    UPDATE saldos SET valor = (valor - valor_in)
        WHERE cliente_id = cliente_id_in
            AND (valor - valor_in) > - (
                SELECT limite FROM clientes WHERE id = cliente_id_in LIMIT 1
            );
    IF NOT FOUND THEN
        ret := NULL;
        RETURN ret;
    END IF;

    INSERT INTO transacoes(cliente_id, valor, tipo, descricao)
        VALUES (cliente_id_in, valor_in, 'd' ,descricao_in);

    SELECT to_json(rw) FROM (
        SELECT limite, saldos.valor as saldo
            FROM clientes
                INNER JOIN saldos ON clientes.id = saldos.cliente_id
            WHERE clientes.id = cliente_id_in
            LIMIT 1
    ) rw
        INTO ret;

    RETURN ret;
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
            'saldo',                (SELECT to_json(sld) FROM (
                                        SELECT saldos.valor AS total, LOCALTIMESTAMP AS data_extrato, limite
                                            FROM clientes
                                                INNER JOIN saldos ON clientes.id = saldos.cliente_id
                                            WHERE clientes.id = cliente_id_in
                                            LIMIT 1)
                                        sld),

            'ultimas_transacoes',   (SELECT coalesce(json_agg(tr), '[]'::json) FROM
                                        (SELECT valor, tipo, descricao, realizada_em
                                            FROM transacoes WHERE cliente_id = cliente_id_in
                                            ORDER BY realizada_em DESC
                                            LIMIT 10)
                                        tr)
        ) INTO ret;        
    
        IF NOT FOUND THEN
            ret := NULL;
            RETURN ret;
        END IF;

    RETURN ret;

END
$$;