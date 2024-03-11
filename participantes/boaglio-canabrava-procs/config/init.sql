CREATE UNLOGGED TABLE IF NOT EXISTS accounts (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	limit_amount INTEGER NOT NULL
);

CREATE UNLOGGED TABLE IF NOT EXISTS transactions (
	id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	transaction_type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	date TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_accounts_transactions_id
		FOREIGN KEY (account_id) REFERENCES accounts(id)
);

CREATE UNLOGGED TABLE IF NOT EXISTS balances (
	id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	CONSTRAINT fk_accounts_balances_id
		FOREIGN KEY (account_id) REFERENCES accounts(id)
);

DO $$
BEGIN
	INSERT INTO accounts (name, limit_amount)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);
	
	INSERT INTO balances (account_id, amount)
		SELECT id, 0 FROM accounts;
END;
$$;

CREATE INDEX IF NOT EXISTS idx_cliente_id ON transactions (account_id); 

CREATE EXTENSION IF NOT EXISTS pg_prewarm;

SELECT pg_prewarm('accounts');

SELECT pg_prewarm('transactions');

SELECT pg_prewarm('balances');


CREATE OR REPLACE FUNCTION update_transaction_and_balance(
    IN account INT,
    IN transaction_amount NUMERIC,
    IN transaction_description TEXT,
    IN transaction_type CHAR
)
RETURNS JSON AS
$$
DECLARE
    operation INT;
    total_balance NUMERIC;
BEGIN

    IF transaction_type = 'd' THEN

        SELECT (accounts.limit_amount + balances.amount)
        INTO total_balance
        FROM accounts
        LEFT JOIN balances ON balances.account_id = accounts.id
        WHERE accounts.id = account;

        IF total_balance < transaction_amount THEN
            RAISE EXCEPTION 'Invalid transaction: Insufficient funds';
        END IF;

        operation := -1;

    ELSIF transaction_type = 'c' THEN
        operation := 1;
    ELSE
        RAISE EXCEPTION 'Invalid transaction type';
    END IF;

    INSERT INTO transactions (account_id, amount, description, transaction_type)
    VALUES (account, transaction_amount, transaction_description, transaction_type);

    UPDATE balances
    SET amount = amount + operation * transaction_amount
    WHERE balances.account_id = account; 

    RETURN (
        SELECT json_build_object(
            'limite', accounts.limit_amount,
            'saldo', balances.amount
        )
        FROM accounts
        LEFT JOIN balances ON balances.account_id = accounts.id
        WHERE accounts.id = account
    );
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_bank_statement(account INT)
RETURNS JSON AS
$$
DECLARE
    statement_json JSON;
BEGIN
    SELECT json_build_object('saldo', json_build_object(
        'total', balances.amount,
        'data_extrato', NOW()::date,
        'limite', accounts.limit_amount,
        'ultimas_transacoes',
            CASE
                WHEN COUNT(transactions) = 0 THEN '[]'
                ELSE
                    json_agg(
                        json_build_object(
                            'valor', transactions.amount,
                            'tipo', transactions.transaction_type,
                            'descricao', transactions.description,
                            'realizada_em', TO_CHAR(transactions.date, 'YYYY-MM-DD HH:MI:SS.US')
                        )
                    )
            END
    ))
    INTO statement_json
    FROM accounts
    LEFT JOIN balances ON balances.account_id = accounts.id
    LEFT JOIN (
        SELECT *
        FROM transactions
        WHERE account_id = account
        ORDER BY date DESC
        LIMIT 10
    ) AS transactions ON transactions.account_id = accounts.id
    WHERE accounts.id = account
    GROUP BY accounts.id, balances.amount, accounts.limit_amount;

    RETURN statement_json;
END;
$$
LANGUAGE plpgsql;

