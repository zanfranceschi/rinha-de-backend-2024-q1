-- Coloque scripts iniciais aqui
CREATE TABLE clientes (
                          id serial primary key,
                          name varchar(100) not null,
                          "limit" bigint not null,
                          balance bigint not null default 0,
                          version integer not null default 0,
                          created_at timestamp default CURRENT_TIMESTAMP,
                          updated_at timestamp default CURRENT_TIMESTAMP
);

create table transactions (
                              id serial primary key,
                              description varchar(10) not null,
                              value bigint not null,
                              transaction_type varchar(1) not null,
                              client_id integer not null,
                              created_at timestamp default CURRENT_TIMESTAMP,
                              updated_at timestamp default CURRENT_TIMESTAMP
);

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