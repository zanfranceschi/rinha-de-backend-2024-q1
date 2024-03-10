create unlogged table if not exists account
(
    account_id  integer primary key,
    limit_value integer not null,
    balance     integer not null default 0
);

create unlogged table if not exists transaction
(
    transaction_id serial primary key,
    account_id     integer     not null,
    value          integer     not null,
    type           varchar(1)  not null,
    description    varchar(10) not null,
    created_at     timestamp   not null
);

create index if not exists idx_transaction_statement on transaction (created_at, account_id);

insert into account (account_id, limit_value, balance)
values (1, 100000, 0),
       (2, 80000, 0),
       (3, 1000000, 0),
       (4, 10000000, 0),
       (5, 500000, 0);