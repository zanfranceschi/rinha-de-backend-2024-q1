CREATE UNLOGGED TABLE Customer
(
 Id SERIAL NOT NULL PRIMARY KEY,
 "Limit" INT NOT NULL,
 Balance INT NOT NULL
);
CREATE UNLOGGED TABLE Balance_Transaction
(
 Id SERIAL NOT NULL PRIMARY KEY,
 CustomerId INT NOT NULL,
 ValueInCents INT NOT NULL,
 IsCredit boolean NOT NULL, -- i think here could be a bit, but i had troubles to pass the value in c#
 Description VARCHAR(10) NOT NULL,
 CreateDate timestamp NOT NULL
);
ALTER TABLE Balance_Transaction ADD CONSTRAINT FK_Balance_Transaction_Customer FOREIGN KEY (CustomerId) References Customer(Id);
CREATE OR REPLACE FUNCTION Stp_DebtTransaction(
    CustomerId INT,
    Value INT
)
RETURNS TABLE(l int, b int) 
LANGUAGE 'plpgsql'
AS $$
BEGIN
	RETURN QUERY 
	UPDATE Customer
	SET Balance = Balance - Value
	WHERE Id = CustomerId AND (Balance - Value) >= -"Limit"
	RETURNING Customer."Limit", Customer.Balance;
END;
$$;
CREATE OR REPLACE FUNCTION Stp_CreditTransaction(
    CustomerId INT,
    Value INT
)
RETURNS TABLE(l int, b int) 
LANGUAGE 'plpgsql'
AS $$
BEGIN
	RETURN QUERY 
	UPDATE Customer
	SET Balance = Balance + Value
	WHERE Id = CustomerId
	RETURNING Customer."Limit", Customer.Balance;
END;
$$;
INSERT INTO Customer ("Limit",Balance) VALUES (100000, 0);
INSERT INTO Customer ("Limit",Balance) VALUES (80000, 0);
INSERT INTO Customer ("Limit",Balance) VALUES (1000000, 0);
INSERT INTO Customer ("Limit",Balance) VALUES (10000000, 0);
INSERT INTO Customer ("Limit",Balance) VALUES (500000, 0);