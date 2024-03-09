CREATE TABLE IF NOT EXISTS client_account (
    id smallint PRIMARY KEY,
    name VARCHAR(23),
    acc_limit integer,
    balance integer,
    generation integer
);

CREATE TABLE IF NOT EXISTS transaction (
    id SERIAL PRIMARY KEY,
    account_id smallint references client_account(id),
    value integer,
    type char(1),
    description varchar(10),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_client_account FOREIGN KEY (account_id) REFERENCES client_account(id)
);

INSERT INTO client_account (id, name, acc_limit, balance, generation)
VALUES
    (1, 'o barato sai caro', 1000 * 100, 0, 1),
    (2, 'zan corp ltda', 800 * 100, 0, 1),
    (3, 'les cruders', 10000 * 100, 0, 1),
    (4, 'padaria joia de cocaia', 100000 * 100, 0, 1),
    (5, 'kid mais', 5000 * 100, 0, 1);


CREATE INDEX IF NOT EXISTS idx_client_account_id ON client_account (id);
CREATE INDEX IF NOT EXISTS idx_client_account_generation ON client_account (generation);
CREATE INDEX IF NOT EXISTS idx_transaction_account_id_created_at ON transaction (account_id, created_at DESC);
