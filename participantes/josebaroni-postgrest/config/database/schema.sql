create role web_anon nologin;
grant usage on schema public to web_anon;

CREATE TABLE clients
(
    id            INT PRIMARY KEY,
    account_limit INTEGER NOT NULL,
    balance       INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transactions
(
    id          SERIAL PRIMARY KEY,
    client_id   INTEGER     NOT NULL,
    amount      INTEGER     NOT NULL,
    operation   CHAR(1)     NOT NULL,
    description VARCHAR(10) NOT NULL,
    created_at  TIMESTAMP   NOT NULL DEFAULT NOW()
);

ALTER TABLE transactions SET (autovacuum_enabled = false);

DO
$$
BEGIN
INSERT INTO clients (id, account_limit)
VALUES (1, 100000),
       (2, 80000),
       (3, 1000000),
       (4, 10000000),
       (5, 500000);
END;
$$;


CREATE OR REPLACE FUNCTION create_transaction(
    _client_id INTEGER,
    _amount NUMERIC,
    _operation CHAR(1),
    _description VARCHAR(10)
) RETURNS json AS $$
DECLARE
    _account_limit integer;
    _account_balance integer;
    _account_new_balance integer;
BEGIN

IF _client_id IS NULL THEN
    RAISE sqlstate 'PT422';
END IF;


IF _amount IS NULL OR _amount <= 0 OR _amount <> _amount::INTEGER THEN
    RAISE sqlstate 'PT422';
END IF;


IF _operation IS NULL OR (_operation <> 'c' AND _operation <> 'd') THEN
    RAISE sqlstate 'PT422';
END IF;


IF _description IS NULL OR LENGTH(_description) < 1 OR LENGTH(_description) > 10 THEN
    RAISE sqlstate 'PT422';
END IF;


IF _client_id > 5 THEN
    RAISE sqlstate 'PT404';
END IF;

SELECT account_limit, balance INTO _account_limit, _account_balance FROM clients WHERE id = _client_id FOR UPDATE;

IF _operation = 'c' THEN
    _account_new_balance := _account_balance + _amount;
ELSIF _operation = 'd' THEN
    _account_new_balance := _account_balance - _amount;
END IF;

IF (_account_limit + _account_new_balance) < 0 THEN
    RAISE sqlstate 'PT422';
END IF;

UPDATE clients SET balance = _account_new_balance WHERE id = _client_id;
INSERT INTO transactions(client_id,amount,operation,description) values (_client_id,_amount,_operation,_description);

RETURN jsonb_build_object('limite', _account_limit, 'saldo', _account_new_balance);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_extract(
    _client_id INTEGER
) RETURNS json AS $$
DECLARE
_client_info JSON;
_last_transactions JSON;
_res JSON;
BEGIN

IF _client_id > 5 THEN
    RAISE sqlstate 'PT404';
END IF;

SELECT json_build_object(
    'total', c.balance,
    'data_extrato', NOW(),
    'limite', c.account_limit
)
INTO _client_info
FROM clients c WHERE id = _client_id;


SELECT json_agg(
               json_build_object(
                       'valor', t.amount,
                       'tipo', t.operation,
                       'descricao', t.description,
                       'realizada_em', t.created_at
                   )
           )
FROM (
         SELECT
             t.amount,
             t.operation,
             t.description,
             t.created_at
         FROM transactions t
         WHERE t.client_id = _client_id
    ORDER BY t.id DESC
    LIMIT 10
     ) t
    INTO _last_transactions;


SELECT json_build_object (
    'saldo', _client_info,
    'ultimas_transacoes', _last_transactions
)
INTO _res;

RETURN _res;
END;
$$ LANGUAGE plpgsql;


-- nao faça isso em prod pelo amor de deus
GRANT SELECT, INSERT, UPDATE, DELETE ON clients TO web_anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON transactions TO web_anon;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO web_anon;