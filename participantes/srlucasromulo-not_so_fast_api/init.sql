\c rinha;


CREATE TABLE cliente (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL DEFAULT 0
);


CREATE TABLE transacao (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES cliente(id),
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP DEFAULT NOW()
);


CREATE OR REPLACE PROCEDURE init_db() AS $$
BEGIN
    INSERT INTO cliente(limite)
        VALUES
            (100000),
            (80000),
            (1000000),
            (10000000),
            (500000)
    ;
END;
$$ LANGUAGE plpgsql;

CALL init_db();


CREATE OR REPLACE PROCEDURE reset_db() AS $$
BEGIN
    TRUNCATE TABLE cliente RESTART IDENTITY CASCADE;
    CALL init_db();
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION creditar(_cliente_id INT, _valor INT, _descricao VARCHAR(10)) RETURNS JSONB AS $$
DECLARE
    record RECORD;
BEGIN
    PERFORM saldo FROM cliente WHERE id = _cliente_id LIMIT 1 FOR NO KEY UPDATE;

    IF NOT FOUND THEN
        RAISE SQLSTATE '22000';     -- cliente not found
    END IF;

    UPDATE cliente SET saldo = saldo + _valor WHERE id = _cliente_id
        RETURNING limite, saldo INTO record;
    INSERT INTO transacao (cliente_id, valor, tipo, descricao) VALUES (_cliente_id, _valor, 'c', _descricao);

    RETURN jsonb_build_object('limite', record.limite, 'saldo', record.saldo);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION debitar(_cliente_id INT, _valor INT, _descricao VARCHAR(10)) RETURNS JSONB AS $$
DECLARE
    record RECORD;
    saldo_atual int;
    limite_cliente int;
BEGIN
    SELECT limite, saldo INTO limite_cliente, saldo_atual FROM cliente WHERE id = _cliente_id LIMIT 1 FOR NO KEY UPDATE;

    IF NOT FOUND THEN
        RAISE SQLSTATE '22000';     -- cliente not found
    END IF;

    IF saldo_atual - _valor >= limite_cliente * -1 THEN
        UPDATE cliente SET saldo = saldo - _valor WHERE id = _cliente_id
            RETURNING limite, saldo INTO record;
        INSERT INTO transacao (cliente_id, valor, tipo, descricao) VALUES (_cliente_id, _valor, 'd', _descricao);
    ELSE
        RAISE SQLSTATE '23000';     -- limite excedido
    END IF;

    RETURN jsonb_build_object('limite', record.limite, 'saldo', record.saldo);
END;
$$ LANGUAGE plpgsql;
