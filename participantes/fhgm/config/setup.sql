CREATE UNLOGGED TABLE Balance
(
	Id         SERIAL PRIMARY KEY,
	CustomerId INT NOT NULL,
	Amount     INT NOT NULL,
	UpdatedAt  TIMESTAMP NOT NULL
);

CREATE UNLOGGED TABLE Transaction
(
	Id              SERIAL PRIMARY KEY,
	CustomerId      INT NOT NULL,
	Amount          INT NOT NULL,
	TransactionType CHAR(1) NOT NULL,
	Description     VARCHAR(10) NOT NULL,
	CreatedAt       TIMESTAMP NOT NULL
);

CREATE INDEX transaction_customerId ON transaction (customerId);
CREATE INDEX balance_customerId ON balance (customerId);

CREATE OR REPLACE FUNCTION AddTransaction
(
	customer_id INT
   ,customer_limit INT
   ,transaction_type CHAR(1)
   ,transaction_amount INT
   ,description VARCHAR(10)
)
RETURNS TABLE 
(
    id_balance INT
   ,new_balance INT
   ,has_error BOOL
)
LANGUAGE plpgsql
AS $$
DECLARE
   old_balance INT;   
   new_balance INT;   
BEGIN
	
	PERFORM pg_advisory_xact_lock(customer_id);
	
	SELECT amount INTO old_balance FROM balance WHERE customerId = customer_id;

	IF transaction_type = 'd' AND old_balance - transaction_amount < -customer_limit THEN
		RETURN QUERY       
		SELECT 0 AS id_balance, 0 AS new_balance, TRUE AS has_error;    
	ELSE
	
		new_balance := CASE WHEN transaction_type = 'd' 
							THEN old_balance - transaction_amount
							ELSE old_balance + transaction_amount 
					   END;

		INSERT INTO transaction
		(
			customerId
		   ,amount
		   ,transactionType
		   ,description
		   ,createdAt
		)
		VALUES
		(
			customer_id
		   ,transaction_amount
		   ,transaction_type
		   ,description
		   ,NOW()
		);
		
		UPDATE balance SET amount = new_balance, updatedAt = NOW() WHERE customerId = customer_id;
		
		RETURN QUERY
		
		SELECT id AS id_balance, amount AS new_balance, FALSE AS has_error FROM balance WHERE customerId = customer_id;

	END IF;

END $$;

DO $$ 
BEGIN
	
	INSERT INTO Balance (CustomerId, Amount, UpdatedAt) VALUES (1, 0, NOW());
    INSERT INTO Balance (CustomerId, Amount, UpdatedAt) VALUES (2, 0, NOW());
    INSERT INTO Balance (CustomerId, Amount, UpdatedAt) VALUES (3, 0, NOW());
    INSERT INTO Balance (CustomerId, Amount, UpdatedAt) VALUES (4, 0, NOW());
    INSERT INTO Balance (CustomerId, Amount, UpdatedAt) VALUES (5, 0, NOW());

END $$;