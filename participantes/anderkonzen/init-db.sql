create table clients
(
    id              bigserial
        primary key,
    "limit"         integer,
    opening_balance integer,
    current_balance integer,
    inserted_at     timestamp(0) not null,
    updated_at      timestamp(0) not null
);

alter table clients
    add constraint current_balance_within_limit
        check (abs(current_balance) < "limit");

create table transactions
(
    id          bigserial
        primary key,
    value       integer,
    type        varchar(255),
    description varchar(255),
    client_id   bigint
        references clients
            on delete cascade,
    inserted_at timestamp(0) not null,
    updated_at  timestamp(0) not null
);

create index transactions_client_id_index
    on transactions (client_id);

do $$
begin
    insert into clients (id, "limit", opening_balance, current_balance, inserted_at, updated_at)
    values
        (1,   100000, 0, 0, now(), now()),
        (2,    80000, 0, 0, now(), now()),
        (3,  1000000, 0, 0, now(), now()),
        (4, 10000000, 0, 0, now(), now()),
        (5,   500000, 0, 0, now(), now());
end; $$

