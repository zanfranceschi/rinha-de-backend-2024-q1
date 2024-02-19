CREATE TABLE IF NOT EXISTS customers
(
    customer_id     BIGSERIAL       PRIMARY KEY,
    customer_name   VARCHAR(100)    NOT NULL,
    account_limit   INT             NOT NULL
);

INSERT INTO customers (customer_name, account_limit)
VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);

CREATE TYPE transaction_type AS ENUM ('c', 'd');

CREATE TABLE IF NOT EXISTS transactions
(
    transaction_id  UUID                NOT NULL    DEFAULT gen_random_uuid(),
    customer_id     INT                 NOT NULL,
    type            transaction_type    NOT NULL,
    value           INT                 NOT NULL,
    description     VARCHAR(10)        NOT NULL,
    last_balance    INT                 NOT NULL,
    created_at      TIMESTAMPTZ         NOT NULL    DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id),
    CONSTRAINT transactions_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id)
);
CREATE INDEX idx_last_transaction_per_customer ON transactions (customer_id, created_at DESC);
