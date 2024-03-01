create type transaction_type as enum ('c', 'd');

create table if not exists transactions
(
    transaction_id bigserial primary key,
    customer_id smallint not null,
    type transaction_type not null,
    value int not null,
    description varchar(10) not null,
    last_balance int not null,
    created_at timestamptz not null default current_timestamp
);
create index idx_last_transaction_per_customer on transactions (customer_id, created_at desc);

create or replace function make_transaction(
    customer int,
    transaction_type transaction_type,
    value int,
    description varchar(10),
    account_limit int
)
returns int as $$
declare
    balance int;
begin
    select coalesce(
        (   select t.last_balance
            from transactions t
            where t.customer_id = customer
            order by t.created_at desc
            limit 1
        ),
        0
    ) into balance;

    balance := balance + case when transaction_type = 'c' then value else -value end;

    if transaction_type = 'd' and balance < -account_limit then
        raise exception 'insufficient funds';
    end if;

    insert into transactions (customer_id, type, value, description, last_balance)
    values (customer, transaction_type, value, description, balance);

    return balance;
end;
$$ language plpgsql;
