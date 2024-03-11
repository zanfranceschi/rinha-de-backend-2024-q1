/*
##### Rinha de Backend ######
#   Revanche dos Javeiros   #
#############################
*/

DROP SCHEMA IF EXISTS api CASCADE;
CREATE SCHEMA api;

SET search_path TO api;
ALTER DATABASE rinhadb SET search_path TO api;

SET TIME ZONE 'UTC';

CREATE TYPE TXTYPE AS ENUM ('c', 'd');

CREATE UNLOGGED TABLE bank_accounts (
    id                BIGSERIAL,
    credit_limit      BIGINT NOT NULL DEFAULT 0 CHECK ( credit_limit >= 0 ),
    balance           BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);

CREATE UNLOGGED TABLE bank_transactions (
    id              BIGSERIAL,
    account_id      BIGINT NOT NULL,
    type            TXTYPE NOT NULL,
    amount          BIGINT NOT NULL CHECK ( amount > 0 ),
    description     VARCHAR(10) NOT NULL,
    issued_at       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    PRIMARY KEY (id),
    FOREIGN KEY (account_id) REFERENCES bank_accounts (id)
);

CREATE INDEX idx_tx_account_id ON bank_transactions (account_id);
CREATE INDEX idx_tx_issued_filter ON bank_transactions (issued_at DESC);

GRANT INSERT ON bank_accounts TO duke;
GRANT UPDATE ON bank_accounts TO duke;
REVOKE DELETE ON bank_accounts FROM duke;

GRANT INSERT ON bank_transactions TO duke;
REVOKE UPDATE ON bank_transactions FROM duke;
REVOKE DELETE ON bank_transactions FROM duke;

INSERT INTO bank_accounts
       (credit_limit, balance)
VALUES (1000 * 100, 0),   -- 1 | $1,000.00 == 100000
       (800 * 100, 0),  -- 2 | $80,000.00 == 80000
       (10000 * 100, 0),  -- 3 | $10,000.00 == 1000000
       (100000 * 100, 0), -- 4 | $100,000.00 == 10000000
       (5000 * 100, 0);   -- 5 | $5,000.00 == 500000