CREATE TABLE client (
    id SERIAL PRIMARY KEY,
    "name" VARCHAR(50) NOT NULL,
    "limit" NUMERIC(10) NOT NULL,
    amount NUMERIC(10) NOT NULL
);

CREATE UNLOGGED TABLE operation (
    id SERIAL,
    client_id INTEGER NOT NULL,
    amount NUMERIC(10) NOT NULL,
    nature CHAR(1) NOT NULL,
    op_description VARCHAR(10) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id, nature),
    CONSTRAINT fk_client_transaction_id
        FOREIGN KEY (client_id) REFERENCES client(id)
) PARTITION BY LIST(nature);

CREATE UNLOGGED TABLE credit_transaction PARTITION OF operation for VALUES IN('c');
CREATE UNLOGGED TABLE debit_transaction PARTITION OF operation for VALUES IN('d');
REVOKE UPDATE,DELETE,TRUNCATE ON operation from CURRENT_ROLE;


CREATE OR REPLACE VIEW account_statement AS
    SELECT s.client_id, jsonb_pretty(jsonb_agg(json_data)) acc_statement FROM
        (SELECT
            c.id as client_id, json_build_object(
                'saldo', json_build_object(
                    'total', c.amount,
                    'limite', c."limit",
                    'data_extrato', now()
                    ),
                'ultimas_transacoes', COALESCE(
                    (SELECT json_agg(row_to_json(t)) FROM (
                        SELECT amount as "valor", nature as "tipo", op_description as "descricao", TO_CHAR(created_at, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"') as realizada_em
                        FROM operation op
                        WHERE op.client_id = c.id
                        ORDER BY created_at DESC
                        LIMIT 10
                        ) t
                    ), '[]'
                )
            ) AS json_data
            FROM client AS c
            ) s group by s.client_id;

CREATE TYPE OP_RESULT AS (balance INT, "limit" INT);


CREATE OR REPLACE FUNCTION apply_operation_and_update_balance(op_client INT, op_type VARCHAR, op_amount INT , op_description VARCHAR)
    RETURNS OP_RESULT AS $$
    DECLARE
        acc_balance INT;
        variation INT;
        c_name VARCHAR;
        result OP_RESULT;
    BEGIN
        PERFORM 1 FROM client where id=op_client FOR UPDATE;
        SELECT "limit", amount from client where id=op_client INTO result."limit", acc_balance;

        IF op_type = 'd' THEN
            variation := op_amount * -1;
        ELSE
            variation := op_amount;
        END IF;

        UPDATE client
                SET amount= (amount + variation)
                WHERE id=op_client
                RETURNING amount INTO result.balance;

        RAISE NOTICE '%s %s %s', acc_balance, variation, result."limit";
        IF (acc_balance + variation) < (result."limit" * -1) THEN
            RAISE NOTICE 'LIMIT EXCEEDED FOR CLIENT (%,%,%)', acc_balance, op_amount, result."limit" USING ERRCODE='numeric_value_out_of_range';
            ROLLBACK;
            RETURN result;
        ELSE
            INSERT INTO operation (client_id, nature, amount, op_description) VALUES (op_client, op_type, op_amount, op_description);
            RETURN result;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE 'OPERATION FAILED WITH ERROR % - %', SQLSTATE, SQLERRM;
            ROLLBACK;
        RETURN result;
    END;
$$ LANGUAGE plpgsql;


DO $$
BEGIN
  INSERT INTO client (name, "limit", amount)
  VALUES
    ('o barato sai caro', 1000 * 100, 0),
    ('zan corp ltda', 800 * 100, 0),
    ('les cruders', 10000 * 100, 0),
    ('padaria joia de cocaia', 100000 * 100, 0),
    ('kid mais', 5000 * 100, 0);
END; $$
