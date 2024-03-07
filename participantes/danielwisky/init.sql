-- clients
CREATE UNLOGGED TABLE clients (
  id bigserial NOT NULL,
  account_limit numeric(38) NOT NULL,
  balance numeric(38) NOT NULL,
  last_modified_date timestamp NOT NULL,
  CONSTRAINT clients_pkey PRIMARY KEY (id)
);

-- transactions
CREATE UNLOGGED TABLE transactions (
  id bigserial NOT NULL,
  transaction_type bpchar(1) NOT NULL,
  value numeric(38) NOT NULL,
  client_id int8 NOT NULL,
  description varchar(10) NOT NULL,
  created_at timestamp NOT NULL,
  CONSTRAINT transactions_pkey PRIMARY KEY (id),
  CONSTRAINT fk_transactions_clients FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE INDEX idx_transactions_client_id_created_at ON transactions (client_id, created_at DESC);

-- insert clients
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
