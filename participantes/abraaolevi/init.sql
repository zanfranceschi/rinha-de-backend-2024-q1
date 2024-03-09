drop table if exists accounts;
drop table if exists transactions;

create unlogged table accounts (
    id serial primary key,
    account_limit bigint,
    balance bigint
);

create unlogged table transactions (
    id serial primary key,
    account_id serial references accounts (id),
    amount bigserial,
    operation char(1),
    description varchar(10),
    created_at timestamp default current_timestamp 
);

create index if not exists idx_transaction_id on transactions(id desc);
create index if not exists idx_account_id_on_transaction on transactions(account_id);

create or replace function update_balance(
    account_id int,
    transaction_type char(1),
    amount numeric,
    transaction_description text,
    out out_message text,
    out out_has_error boolean,
    out out_balance numeric,
    out out_account_limit numeric
) as $$
declare
    account_record record;
    account_balance numeric;
begin
    select account_limit, balance into account_record from accounts where id = account_id for update;

    if not found then
        out_message := 'not_found';
        out_has_error := true;
        out_balance := 0;
        out_account_limit := 0;
        return;
    end if;

    if transaction_type = 'd' then
        account_balance := account_record.balance - amount;

        if account_balance + account_record.account_limit < 0 then 
            out_message := 'insufficient_limit';
            out_has_error := true;
            out_balance := 0;
            out_account_limit := 0;
            return;
        end if;
    else
        account_balance := account_record.balance + amount;
    end if;

    update accounts set balance = account_balance where id = account_id;

    insert into transactions (account_id, amount, operation, description)
        values (account_id, amount, transaction_type, transaction_description);

    out_message := 'ok';
    out_has_error := false;
    out_balance := account_balance;
    out_account_limit := account_record.account_limit;
end;
$$ language plpgsql;

INSERT INTO accounts (id, account_limit, balance) VALUES(1, 100000, 0);
INSERT INTO accounts (id, account_limit, balance) VALUES(2, 80000, 0);
INSERT INTO accounts (id, account_limit, balance) VALUES(3, 1000000, 0);
INSERT INTO accounts (id, account_limit, balance) VALUES(4, 10000000, 0);
INSERT INTO accounts (id, account_limit, balance) VALUES(5, 500000, 0);