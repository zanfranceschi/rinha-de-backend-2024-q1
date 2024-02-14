create table if not exists clients
(
    id      integer primary key,
    "limit" bigint not null default 0,
    balance bigint not null default 0,
    constraint clients_balance_check check (balance >= -"limit")
);

create table if not exists transactions
(
    id          bigserial primary key,
    client_id   integer   not null,
    amount      bigint    not null,
    type        char      not null,
    description text,
    created_at  timestamp not null default current_timestamp
);

create index if not exists transactions_client_id_index on transactions (client_id);

create or replace function create_transaction(client_id integer, amount bigint, type char, description text)
    returns jsonb
    language plpgsql
as
$$
DECLARE
    updated_balance bigint;
    saldo           jsonb;
BEGIN
    INSERT INTO transactions (client_id, amount, type, description)
    VALUES (client_id, amount, type, description);

    UPDATE clients
    SET balance = balance + CASE type WHEN 'c' THEN amount ELSE -amount END
    WHERE id = client_id
    RETURNING balance INTO updated_balance;


    SELECT JSONB_BUILD_OBJECT(
                   'limite', (SELECT (SELECT "limit" FROM clients WHERE id = client_id)),
                   'saldo', updated_balance
           )
    INTO saldo;

    RETURN saldo;
end;
$$;


CREATE OR REPLACE FUNCTION get_extract(client_id integer, OUT response jsonb)
    RETURNS jsonb
    LANGUAGE SQL
AS
$fn$
WITH client AS (SELECT *
                FROM clients
                WHERE id = client_id),
     transactions AS (SELECT JSONB_BUILD_OBJECT(
                                     'valor', t.amount,
                                     'tipo', t.type,
                                     'descricao', t.description,
                                     'realizada_em', t.created_at
                             ) AS transaction_data
                      FROM transactions t
                      WHERE t.client_id = client_id)
SELECT JSONB_BUILD_OBJECT(
               'saldo',
               JSONB_BUILD_OBJECT(
                       'total', client.balance,
                       'data_extrato', to_char(now(), 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"'),
                       'limite', client.limit
               ),
               'ultimas_transacoes',
               case when count(transactions) > 0 then JSONB_AGG(transactions) else '[]' end
       )
FROM client
         LEFT JOIN transactions ON TRUE
GROUP BY client.balance, client.limit;
$fn$;


insert into clients (id, "limit", balance)
values (1, 100000, 0),
       (2, 80000, 0),
       (3, 1000000, 0),
       (4, 10000000, 0),
       (5, 500000, 0);
