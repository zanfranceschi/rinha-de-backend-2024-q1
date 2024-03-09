CREATE TABLE IF NOT EXISTS accounts(
    id SERIAL PRIMARY KEY,
    "limit" INTEGER,
    amount INTEGER,
    inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_amount_limit CHECK (amount >= -"limit"));

CREATE TABLE IF NOT EXISTS transactions(
    id SERIAL PRIMARY KEY,
    value INTEGER NOT NULL,
    description VARCHAR(10) NOT NULL,
    type CHAR NOT NULL,
    account_id INTEGER NOT NULL,
    inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_accounts_id ON accounts (id);
CREATE INDEX idx_accounts_limit ON accounts ("limit");
CREATE INDEX idx_accounts_amount ON accounts ("amount");
CREATE INDEX idx_transactions_account_id ON transactions (account_id);
CREATE INDEX idx_transactions_inserted_at ON transactions (inserted_at);

INSERT INTO accounts ("limit", amount) VALUES 
    (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);
