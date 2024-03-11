drop table if exists "Transactions";
drop table if exists "Clients";

create unlogged table "Clients" (
    "Id" serial primary key,
    "Limit" int,
    "Balance" int check ("Balance" >= "Limit" * -1)
);

insert into "Clients" values
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);

create unlogged table "Transactions" (
    "Id" serial primary key,
    "Amount" int,
    "OperationType" char(1),
    "Description" varchar(10),
    "CreatedAt" timestamp without time zone default now(),
    "ClientId" int
);
