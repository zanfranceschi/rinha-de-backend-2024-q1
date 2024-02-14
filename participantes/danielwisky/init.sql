-- clients definition

-- Drop table

-- DROP TABLE clients;

CREATE TABLE clients (
	account_limit numeric(38) NOT NULL,
	balance numeric(38) NOT NULL,
	id bigserial NOT NULL,
	last_modified_date timestamp(6) NOT NULL,
	CONSTRAINT clients_pkey PRIMARY KEY (id)
);

-- transactions definition

-- Drop table

-- DROP TABLE transactions;

CREATE TABLE transactions (
	transaction_type bpchar(1) NOT NULL,
	value numeric(38) NOT NULL,
	client_id int8 NOT NULL,
	created_at timestamp(6) NOT NULL,
	id bigserial NOT NULL,
	description varchar(10) NOT NULL,
	CONSTRAINT transactions_pkey PRIMARY KEY (id),
	CONSTRAINT fk_transactions_clients FOREIGN KEY (client_id) REFERENCES clients(id)
);

INSERT INTO clients (account_limit, balance, id, last_modified_date)
VALUES(100000, 0, nextval('clients_id_seq'::regclass), '2024-01-01T00:00:00.000Z');

INSERT INTO clients (account_limit, balance, id, last_modified_date)
VALUES(80000, 0, nextval('clients_id_seq'::regclass), '2024-01-01T00:00:00.000Z');

INSERT INTO clients (account_limit, balance, id, last_modified_date)
VALUES(1000000, 0, nextval('clients_id_seq'::regclass), '2024-01-01T00:00:00.000Z');

INSERT INTO clients (account_limit, balance, id, last_modified_date)
VALUES(10000000, 0, nextval('clients_id_seq'::regclass), '2024-01-01T00:00:00.000Z');

INSERT INTO clients (account_limit, balance, id, last_modified_date)
VALUES(500000, 0, nextval('clients_id_seq'::regclass), '2024-01-01T00:00:00.000Z');
