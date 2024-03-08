-- Coloque scripts iniciais aqui
CREATE UNLOGGED TABLE clientes (
                          id serial primary key,
                          name varchar(100) not null,
                          "limit" bigint not null,
                          balance bigint not null default 0,
                          created_at timestamp default CURRENT_TIMESTAMP,
                          updated_at timestamp default CURRENT_TIMESTAMP
);

create UNLOGGED table transactions (
                              id serial primary key,
                              description varchar(10) not null,
                              value bigint not null,
                              transaction_type varchar(1) not null,
                              client_id integer not null,
                              created_at timestamp default CURRENT_TIMESTAMP,
                              updated_at timestamp default CURRENT_TIMESTAMP

);
       alter table transactions
       set (autovacuum_enabled = false);

       create index idx_client_id on transactions(client_id desc);
DO $$
BEGIN
INSERT INTO clientes (name, "limit")
VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$