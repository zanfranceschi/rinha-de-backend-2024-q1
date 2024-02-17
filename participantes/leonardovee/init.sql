ALTER SYSTEM SET max_connections = 200;

CREATE TABLE IF NOT EXISTS clients (
  id SERIAL PRIMARY KEY,
  balance INTEGER NOT NULL DEFAULT 0,
  balance_limit INTEGER NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  client_id INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  type TEXT NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX client_id_index ON transactions USING hash(client_id);

INSERT INTO
  clients (balance_limit)
VALUES
  (100000),
  (80000),
  (1000000),
  (10000000),
  (500000);

create or replace procedure create_transaction(
        p_client_id integer,
        p_amount integer,
        p_type text,
        p_description text,
        inout p_new_balance integer default null,
        inout p_balance_limit integer default null
)
language plpgsql as
$proc$
begin
        with updated as (
                update clients set balance = balance + p_amount
                where id = p_client_id and balance + p_amount >= - balance_limit
                returning balance, balance_limit
        ), inserted as (
                insert into transactions (client_id, amount, type, description)
                values (p_client_id, abs(p_amount), p_type, p_description)
        )
        select balance, balance_limit from updated
        into p_new_balance, p_balance_limit;
commit;
end;
$proc$
