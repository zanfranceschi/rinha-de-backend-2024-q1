create unlogged table "account" (
    "id" smallint not null primary key,
    "limit" bigint not null,
    "balance" bigint not null
);

create unlogged table "transaction" (
    "accountId" smallint not null,
    "amount" bigint not null,
    "kind" char(1) not null,
    "description" text not null,
    "timestamp" timestamp not null,
    constraint fk_account foreign key ("accountId") references "account" ("id")
);

insert into "account" (
    "id",
    "limit",
    "balance"
) values
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);