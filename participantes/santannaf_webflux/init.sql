create table account
(
    customer_id   integer unique primary key not null,
    account_limit integer                    not null,
    balance       integer default 0          not null
);

insert into account (customer_id, account_limit)
values (1, 1000 * 100),
       (2, 800 * 100),
       (3, 10000 * 100),
       (4, 100000 * 100),
       (5, 5000 * 100);

create table transactions
(
    id          varchar(40) not null,
    customer_id integer     not null,
    type        varchar(1)  not null,
    amount      integer     not null,
    description varchar(10) not null,
    created_at  timestamp   not null
);

create index if not exists index_transaction_customer_id on transactions using btree (customer_id);
create index if not exists index_customers_customer_id on account using btree (customer_id);
create index if not exists index_transaction_created_at on transactions (created_at desc);

grant all privileges on database db_financial to admin;