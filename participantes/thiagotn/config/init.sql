CREATE UNLOGGED TABLE accounts (
    id SERIAL PRIMARY KEY,
    account_limit integer,
    balance integer
);

CREATE UNLOGGED TABLE transactions (
    id SERIAL PRIMARY KEY,
    value integer,
    transaction_type character varying(10),
    description character varying(10),
    created_at timestamp without time zone,
    account_id integer NOT NULL,
    CONSTRAINT fk_accounts_transactions_id
		FOREIGN KEY (account_id) REFERENCES accounts(id)
);

DO $$
BEGIN
	INSERT INTO accounts (account_limit, balance) 
    VALUES (100000, 0), (80000, 0),	(1000000, 0), (10000000, 0), (500000, 0);
END;
$$;

CREATE OR REPLACE FUNCTION CreateTransaction(
    IN accountId INT, 
    IN amount INT,
    IN description VARCHAR,
    IN transactionType VARCHAR
)
RETURNS TABLE (limite INT, saldo INT)
LANGUAGE plpgsql    
AS $$
DECLARE
    actualLimit INT;
    actualBalance INT;
BEGIN
    SELECT account_limit, balance INTO actualLimit, actualBalance FROM accounts WHERE id = accountId FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Conta não encontrada';
    END IF;

    IF transactionType = 'd' THEN
        IF amount < 0 THEN
            RAISE EXCEPTION 'Valor não pode ser negativo';
        END IF;

        IF (actualBalance - amount) > actualLimit THEN
            RAISE EXCEPTION 'Valor é maior que o seu saldo + limite';
        END IF;

        actualBalance = actualBalance - amount;
        IF (abs(actualBalance) > actualLimit) THEN
            RAISE EXCEPTION 'Limite excedido';
        END IF;
    END IF;

    IF transactionType = 'c' THEN
        actualBalance = actualBalance + amount;
    END IF;

    UPDATE accounts
    SET balance = actualBalance
    WHERE id = accountId;

    INSERT INTO transactions (account_id, value, transaction_type, description, created_at)
    VALUES (accountId, amount, transactionType, description, (NOW() at time zone 'utc'));

    RETURN QUERY SELECT actualLimit, actualBalance;
END;$$;