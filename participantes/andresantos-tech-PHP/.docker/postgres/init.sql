CREATE TABLE accounts (
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(30) NOT NULL,
                          limit_amount INTEGER NOT NULL,
                          current_balance INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE transactions (
                              id SERIAL PRIMARY KEY,
                              account_id INTEGER NOT NULL,
                              amount INTEGER NOT NULL,
                              transaction_type CHAR(1) NOT NULL,
                              description VARCHAR(10) NOT NULL,
                              date TIMESTAMP NOT NULL DEFAULT NOW(),
                              CONSTRAINT fk_accounts_transactions FOREIGN KEY (account_id) REFERENCES accounts(id)
);

DO $$
BEGIN

INSERT INTO accounts (name, limit_amount, current_balance)
VALUES
    ('Daenerys Targaryen', 1000 * 100, 0),
    ('Jon Snow', 800 * 100, 0),
    ('Cersei Lannister', 10000 * 100, 0),
    ('Tywin Lannister', 100000 * 100, 0),
    ('Arya Stark', 5000 * 100, 0);

PERFORM * FROM accounts INNER JOIN transactions t on accounts.id = t.account_id
         WHERE accounts.id >= 1;

END;
$$;