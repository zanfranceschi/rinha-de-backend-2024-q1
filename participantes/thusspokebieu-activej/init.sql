
CREATE UNLOGGED TABLE IF NOT EXISTS clientes (
	id SERIAL PRIMARY KEY,
	limite INTEGER NOT NULL,
  saldo INTEGER NOT NULL 
);

CREATE INDEX IF NOT EXISTS idx_clientes ON clientes USING btree(id);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
    ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_transacoes_cliente_id ON transacoes USING btree(cliente_id);

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM clientes) THEN
        INSERT INTO clientes (limite, saldo)
        VALUES
            (1000 * 100, 0),
            (800 * 100, 0),
            (10000 * 100, 0),
            (100000 * 100, 0),
            (5000 * 100, 0);
    END IF;
END;
$$;



CREATE OR REPLACE FUNCTION extrato(_cliente_id INTEGER)
RETURNS JSON AS $$
DECLARE
    saldo JSON;
    ultimas_transacoes JSON;
BEGIN
    SELECT
        json_build_object(
            'total', c.saldo,
            'data_extrato', NOW(),
            'limite', c.limite
        )
    INTO
        saldo
    FROM
        clientes c
    WHERE
        c.id = _cliente_id;

    IF NOT FOUND THEN 
      RETURN NULL;
    END IF;

    SELECT
        CASE
            WHEN COUNT(*) > 0 THEN json_agg(json_build_object(
                'valor', t.valor,
                'tipo', t.tipo,
                'descricao', t.descricao,
                'realizada_em', t.realizada_em
            ))
            ELSE '[]'::JSON
        END
    INTO
        ultimas_transacoes
    FROM (
        SELECT
            valor,
            tipo,
            descricao,
            realizada_em
        FROM
            transacoes
        WHERE
            cliente_id = _cliente_id
        ORDER BY
            id DESC
        LIMIT 10
    ) t;

    RETURN json_build_object(
        'saldo', saldo,
        'ultimas_transacoes', ultimas_transacoes
    );
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION transacao(
    _cliente_id INTEGER,
    _valor INTEGER,
    _tipo CHAR,
    _descricao VARCHAR(10),
    OUT codigo_erro SMALLINT,
    OUT resultado JSON
)
RETURNS record AS
$$
BEGIN
        IF _tipo = 'c' THEN
            UPDATE clientes 
            SET saldo = saldo + _valor 
            WHERE id = _cliente_id 
            RETURNING json_build_object('limite', limite, 'saldo', saldo) INTO resultado;
            INSERT INTO transacoes(cliente_id, valor, tipo, descricao)
            VALUES (_cliente_id, _valor, _tipo, _descricao);
            RETURN;
        ELSIF _tipo = 'd' THEN
            UPDATE clientes
            SET saldo = saldo - _valor
            WHERE id = _cliente_id AND saldo - _valor > -limite
            RETURNING json_build_object('limite', limite, 'saldo', saldo) INTO resultado;
            
            IF FOUND THEN 
              INSERT INTO transacoes(cliente_id, valor, tipo, descricao)
              VALUES (_cliente_id, _valor, _tipo, _descricao);
            ELSE 
              codigo_erro := 2;
              resultado := NULL;
            END IF;

            RETURN;
        ELSE
            codigo_erro := 2;
            resultado := NULL;
            RETURN;
        END IF;
END;
$$
LANGUAGE plpgsql;

