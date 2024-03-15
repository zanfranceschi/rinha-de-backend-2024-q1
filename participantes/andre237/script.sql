create unlogged table client_account (
    id integer not null constraint client_account_v2_pkey primary key,
    "limit" bigint  not null,
    balance bigint  not null,
    constraint client_account_v2_check
        check ((balance > 0) OR (abs(balance) <= "limit"))
);

create unlogged table transaction_requests (
    value       bigint not null,
    type        char   not null,
    description varchar(10),
    created_at  timestamp default CURRENT_TIMESTAMP,
    account_id  integer references client_account
);

create index transaction_requests_account_id_created_at_idx
    on transaction_requests (account_id, created_at);

insert into client_account (id, "limit", balance) VALUES
    (1, 100000, 0), (2, 80000, 0), (3, 1000000, 0), (4, 10000000, 0), (5, 500000, 0);
    