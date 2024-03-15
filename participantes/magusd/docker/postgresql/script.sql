DROP TABLE IF EXISTS accounts;
CREATE UNLOGGED TABLE accounts (
    id SERIAL PRIMARY KEY,
    credit integer,
    balance integer DEFAULT 0
);
DROP TABLE IF EXISTS transactions;
CREATE UNLOGGED TABLE transactions (
    account_id integer,
    amount integer,
    op character(1),
    description character(10),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

DROP INDEX IF EXISTS idx_account_id;
CREATE INDEX idx_account_id ON transactions(account_id);
--explain select * from transactions where account_id = 1 order by created_at, account_id desc;


INSERT INTO "accounts"("id","credit","balance")
VALUES
(1,100000,0),
(2, 80000,0),
(3,1000000,0),
(4,10000000,0),
(5,500000,0);

select * from accounts;
