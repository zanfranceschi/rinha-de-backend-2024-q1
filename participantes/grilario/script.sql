create table client (
  id serial primary key,
  name varchar(50) not null,
  max_limit integer not null,
  balance integer not null default 0
);

create type transaction_type as enum ('credit', 'debit');

create table transaction (
  id serial primary key,
  client_id serial references client(id),
  value integer not null,
  type transaction_type not null,
  description varchar(10) not null,
  created_at timestamptz not null default now()
);

DO $$
BEGIN
  INSERT INTO client (name, max_limit)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$
