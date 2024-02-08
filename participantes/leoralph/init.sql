create table "clients" ("id" bigserial not null primary key, "limite" integer not null, "saldo" bigint not null default '0');
create table "transactions" ("id" bigserial not null primary key, "client_id" bigint not null, "valor" bigint not null, "tipo" varchar(1) not null, "descricao" varchar(10) not null, "realizada_em" varchar(255) not null);
alter table "transactions" add constraint "transactions_client_id_foreign" foreign key ("client_id") references "clients" ("id");
create index "transactions_client_id_id_index" on "transactions" ("client_id", "id");
insert into "clients" ("id", "limite") values (1, 100000), (2, 80000), (3, 1000000), (4, 10000000), (5, 500000) on conflict ("id") do update set "id" = "excluded"."id", "limite" = "excluded"."limite";
