alter table if exists transaction
    drop constraint if exists FK_transaction_client_id;
drop table if exists client cascade;
drop table if exists transaction cascade;
create table client
(
    id      bigserial not null,
    name    varchar(255),
    balance numeric(38, 0) default 0,
    limite  numeric(38, 0) default 0,
    primary key (id)
);
create table transaction
(
    id          bigserial not null,
    client_id   bigint,
    description varchar(255),
    type        char(1),
    value       numeric(38, 0),
    created_at  timestamp(6) default now(),
    primary key (id)
);
alter table if exists transaction
    add constraint FK_transaction_client_id foreign key (client_id) references client;

INSERT INTO client (name, limite)
VALUES ('o barato sai caro', 1000 * 100),
       ('zan corp ltda', 800 * 100),
       ('les cruders', 10000 * 100),
       ('padaria joia de cocaia', 100000 * 100),
       ('kid mais', 5000 * 100);