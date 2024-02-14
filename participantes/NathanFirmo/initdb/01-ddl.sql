CREATE SCHEMA bank AUTHORIZATION admin;

CREATE TABLE bank.clients (
	id int NOT NULL,
	"limit" int NOT NULL,
	balance int NOT NULL DEFAULT 0,
	CONSTRAINT clients_pk PRIMARY KEY (id)
);

CREATE TABLE bank.transactions (
	id bigserial NOT NULL,
	client_id int4 NOT NULL,
	amount int4 NOT NULL DEFAULT 0,
	description varchar(10) NULL,
	"type" char NULL,
	created_at timestamp NULL,
	CONSTRAINT transactions_pk PRIMARY KEY (id)
);

ALTER TABLE bank.transactions ADD CONSTRAINT transactions_clients_fk FOREIGN KEY (client_id) REFERENCES bank.clients(id);
