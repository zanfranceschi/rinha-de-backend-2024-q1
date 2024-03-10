DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS saldo;
DROP TABLE IF EXISTS transacao;

CREATE TABLE cliente (
    cliente_id SERIAL PRIMARY KEY

);

CREATE TABLE saldo (
    saldo_id SERIAL PRIMARY KEY,
    cliente_id SERIAL,
    total INT NOT NULL,
    limite INT NOT NULL,
    CONSTRAINT fk_cliente
        FOREIGN KEY(cliente_id)
            REFERENCES cliente(cliente_id)
);

CREATE TABLE transacao (
    transacao_id SERIAL PRIMARY KEY,
    cliente_id SERIAL,
    valor INT NOT NULL,
    tipo VARCHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMPTZ NOT NULL,
    CONSTRAINT fk_transacao_cliente
        FOREIGN KEY(cliente_id)
            REFERENCES cliente(cliente_id)
);

CREATE INDEX idx_transacoes ON transacao (cliente_id ASC);
CREATE INDEX idx_saldo ON saldo (cliente_id ASC);

CREATE OR REPLACE FUNCTION get_cliente_details(cliente_id_param INT)
RETURNS JSONB AS $$
DECLARE
    saldo_record RECORD;
    transactions_array JSONB;
BEGIN

    SELECT INTO saldo_record * FROM saldo WHERE cliente_id = cliente_id_param LIMIT 1;

     IF NOT FOUND THEN
        RETURN NULL;
    END IF;

    transactions_array = (
        SELECT json_agg(row_to_json(trans))
        FROM (
            SELECT *
            FROM transacao
            WHERE cliente_id = cliente_id_param
            ORDER BY realizada_em DESC
            LIMIT 10
        ) trans
    );

    RETURN jsonb_build_object(
        'cliente_id', cliente_id_param,
        'saldo', jsonb_build_object(
            'saldo_id', saldo_record.saldo_id,
            'total', saldo_record.total,
            'limite', saldo_record.limite,
            'data_extrato', now()
        ),
        'ultimas_transacoes', transactions_array
    );

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION create_transaction(cliente_id_param INT, valor_param INT, tipo_param VARCHAR(1), descricao_param VARCHAR(10), total_param INT, saldo_id_param INT)
RETURNS INT AS $$
DECLARE
    transacao_record RECORD;
    saldo_record RECORD;
    result INT;
BEGIN

    INSERT INTO transacao (cliente_id, valor, tipo, descricao, realizada_em)
    VALUES (cliente_id_param, valor_param, tipo_param, descricao_param, NOW());

    UPDATE INTO result saldo SET total = total_param WHERE saldo_id = saldo_id_param RETURNING saldo_id;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_transaction(cliente_id_param INT,
                                           valor_param INT,
                                           tipo_param VARCHAR(1),
                                           descricao_param VARCHAR(10))
RETURNS JSONB AS $$
DECLARE
    transacao_record RECORD;
    saldo_record RECORD;
    novo_total INT;
BEGIN

    SELECT INTO saldo_record * FROM saldo WHERE cliente_id = cliente_id_param LIMIT 1 FOR UPDATE;

    IF tipo_param = 'c' THEN
      novo_total := saldo_record.total + valor_param;
    ELSIF tipo_param = 'd' THEN
        IF (saldo_record.total - valor_param) < -saldo_record.limite THEN
            RETURN jsonb_build_object(
                'code', 500,
                'reason', 'not_enough_funds'
            );
        END IF;
        novo_total := saldo_record.total - valor_param;
    END IF;

    INSERT INTO transacao (cliente_id, valor, tipo, descricao, realizada_em)
    VALUES (cliente_id_param, valor_param, tipo_param, descricao_param, NOW());

    UPDATE saldo SET total = novo_total WHERE cliente_id = cliente_id_param RETURNING * INTO saldo_record;

    RETURN jsonb_build_object(
        'total', novo_total,
        'limite', saldo_record.limite
    );
END;
$$ LANGUAGE plpgsql;




DO $$
BEGIN
  INSERT INTO cliente (cliente_id)
  VALUES
    (1),
    (2),
    (3),
    (4),
    (5);
END; $$;

DO $$
BEGIN
  INSERT INTO saldo (cliente_id, limite, total)
  VALUES
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);
END; $$
