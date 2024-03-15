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
    client_id   integer        not null,
    amount      bigint not null,
    type        char           not null,
    description text,
    created_at  timestamp      not null default current_timestamp
);

create index if not exists transactions_client_id_index on transactions (client_id);

insert into clients (id, "limit", balance)
values (1, 100000, 0),
       (2, 80000, 0),
       (3, 1000000, 0),
       (4, 10000000, 0),
       (5, 500000, 0);

CREATE OR REPLACE FUNCTION reset_data()
    RETURNS void
    LANGUAGE SQL
AS
$fn$
UPDATE clients
SET balance = 0
WHERE 1 = 1;
DELETE
FROM transactions
WHERE 1 = 1;
$fn$;
