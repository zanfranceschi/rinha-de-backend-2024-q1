create unlogged table account (
    id integer primary key not null,
    balance integer not null,
    overdraft integer not null
);

create unlogged table transaction (
    id serial not null,
    account_id integer not null,
    val integer not null,
    description varchar(10) not null,
    datetime timestamp with time zone not null
);

create index idx_transaction_account_id_id_desc on transaction (
    account_id,
    id desc
);


create or replace view account_check
as
select a.*,
       t.*
    from account a
    left join (
        select account_id,
               sum(val) trans_balance
            from transaction
            group by account_id
    ) t
        on t.account_id = a.id
    where a.balance < a.overdraft or
          coalesce(t.trans_balance, 0) <> a.balance;


create or replace view transaction_check
as
select t.*
    from (
        select id,
            account_id,
            sum(val) over (partition by account_id order by id) balance
            from transaction
    ) t
    join account a
        on a.id = t.account_id
    where t.balance < a.overdraft
    order by t.account_id, t.id;


drop type if exists post_transaction_ret;

create type post_transaction_ret as (
    status_code integer,
    balance integer,
    overdraft integer
);

create or replace function post_transaction(
    in account_id integer,
    in val integer,
    in description varchar(10)
) returns post_transaction_ret
as $$
declare
    ret post_transaction_ret;
begin
    update account
        set balance = balance + val
        where id = account_id and
              (val > 0 or balance + val >= overdraft)
        returning balance, overdraft
        into ret.balance, ret.overdraft;

    if (found) then
        insert into transaction (account_id, val, description, datetime)
            values (account_id, val, description, now());

        ret.status_code = 200;
    else
        perform 1 from account
        where id = account_id
        limit 1;

        if (found) then
            ret.status_code = 422;
        else
            ret.status_code = 404;
        end if;
    end if;

    return ret;
end;
$$ language plpgsql;


insert into account (id, balance, overdraft) values (1, 0, -100000);
insert into account (id, balance, overdraft) values (2, 0, -80000);
insert into account (id, balance, overdraft) values (3, 0, -1000000);
insert into account (id, balance, overdraft) values (4, 0, -10000000);
insert into account (id, balance, overdraft) values (5, 0, -500000);
