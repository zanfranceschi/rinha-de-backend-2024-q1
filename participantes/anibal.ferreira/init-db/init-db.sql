create table customer (
    id int not null primary key,
    credit_limit bigint not null,
    balance bigint not null constraint balance_check check(balance >= (-1 * credit_limit)),
    latest_transactions jsonb
);

create table transactions (
    id uuid not null primary key,
    customer_id int not null references customer(id),
    amount bigint not null,
    transaction_type char(1) not null,
    description varchar(10) not null
);

insert into customer (id, credit_limit, balance) values
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);
