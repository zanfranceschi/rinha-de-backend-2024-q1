DROP SCHEMA if exists public CASCADE;
CREATE SCHEMA public;

GRANT ALL ON SCHEMA public TO rinha;

CREATE TABLE account (id BIGINT NOT NULL, account_limit BIGINT, balance BIGINT NOT NULL, CONSTRAINT account_pkey PRIMARY KEY (id));

CREATE TABLE account_transaction (id SERIAL PRIMARY KEY, type VARCHAR(1) NOT NULL, description VARCHAR(255) NOT NULL, amount BIGINT NOT NULL, create_at TIMESTAMP WITHOUT TIME ZONE NOT NULL, account_id BIGINT NOT NULL);

ALTER TABLE account_transaction ADD CONSTRAINT "fk_account_transaction_Account" FOREIGN KEY (account_id) REFERENCES account (id);

CREATE INDEX "idx_transaction-create-at" ON account_transaction(create_at DESC);

CLUSTER account_transaction USING "idx_transaction-create-at";

INSERT INTO account (id, account_limit, balance) VALUES (1, 100000, 0);

INSERT INTO account (id, account_limit, balance) VALUES (2, 80000, 0);

INSERT INTO account (id, account_limit, balance) VALUES (3, 1000000, 0);

INSERT INTO account (id, account_limit, balance) VALUES (4, 10000000, 0);

INSERT INTO account (id, account_limit, balance) VALUES (5, 500000, 0);