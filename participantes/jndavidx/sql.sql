CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    limit_ INT NOT NULL,
    balance INT NOT NULL
);

INSERT INTO clients (limit_, balance)
VALUES (100000, 0),
       (80000, 0),
       (1000000, 0),
       (10000000, 0),
       (500000, 0);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    client_id SERIAL REFERENCES clients (id),
    value INT NOT NULL,
    type CHAR NOT NULL,
    description VARCHAR (10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX transactions_created_at_index ON transactions (created_at);

CREATE FUNCTION make_transaction (
    _id INT, _value INT, _type CHAR, _description VARCHAR
) RETURNS JSON AS
$$
DECLARE
    _limit INT;
    _balance INT;
BEGIN
    SELECT limit_, balance INTO _limit, _balance
    FROM clients WHERE id = _id FOR UPDATE;

    IF NOT FOUND THEN
        RETURN NULL;
    ELSIF _type = 'd' THEN
        _balance := _balance - _value;
    ELSE
        _balance := _balance + _value;
    END IF;

    IF -_balance > _limit THEN
        RETURN 'false';
    END IF;

    UPDATE clients SET balance = _balance WHERE id = _id;

    INSERT INTO transactions (client_id, value, type, description)
    VALUES (_id, _value, _type, _description);

    RETURN format('{"limite": %s, "saldo": %s}', _limit, _balance);
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION get_statement (_id INT) RETURNS JSON AS
$$
DECLARE
    _balance JSON;
    last_transactions JSON;
BEGIN
    SELECT format(
        '{"total": %s, "limite": %s, "data_extrato": "%s"}',
        balance, limit_, CURRENT_TIMESTAMP::TIMESTAMP
    )
    INTO _balance FROM clients WHERE id = _id;

    IF NOT FOUND THEN
        RETURN NULL;
    END IF;

    SELECT json_agg(
        format(
            '{"valor": %s, "tipo": "%s", "descricao": "%s", "realizada_em": "%s"}',
            value, type, description, created_at
        )::JSON
    )
    INTO last_transactions
    FROM (
        SELECT * FROM transactions
        WHERE client_id = _id ORDER BY created_at DESC LIMIT 10
    );

    RETURN json_build_object(
        'saldo', _balance, 'ultimas_transacoes', last_transactions
    );
END;
$$ LANGUAGE plpgsql;