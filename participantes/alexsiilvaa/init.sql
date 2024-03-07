CREATE UNLOGGED TABLE Customer
(
	Id INT GENERATED ALWAYS AS IDENTITY,
	CreditLimit INT NOT NULL,
	Balance INT NOT NULL default 0,
	CONSTRAINT PK_Customer PRIMARY KEY (Id)
);

CREATE UNLOGGED TABLE FinancialTransaction
(
	Id INT GENERATED ALWAYS AS IDENTITY,
	CustomerId INT NOT NULL,
	Value INT NOT NULL,
	Type CHAR(1) NOT NULL,
	Description VARCHAR(10) NOT NULL,
	ExecutedOn TIMESTAMP NOT NULL,
	CONSTRAINT PK_FinancialTransaction PRIMARY KEY (Id, CustomerId)
)  PARTITION BY RANGE(CustomerId);

CREATE UNLOGGED TABLE FinancialTransaction_default PARTITION of FinancialTransaction default;
CREATE UNLOGGED TABLE FinancialTransaction_1 PARTITION of FinancialTransaction FOR VALUES FROM (1) TO (2);
CREATE UNLOGGED TABLE FinancialTransaction_2 PARTITION of FinancialTransaction FOR VALUES FROM (2) TO (3);
CREATE UNLOGGED TABLE FinancialTransaction_3 PARTITION of FinancialTransaction FOR VALUES FROM (3) TO (4);
CREATE UNLOGGED TABLE FinancialTransaction_4 PARTITION of FinancialTransaction FOR VALUES FROM (4) TO (5);
CREATE UNLOGGED TABLE FinancialTransaction_5 PARTITION of FinancialTransaction FOR VALUES FROM (5) TO (6);

CREATE INDEX IDX_FinancialTransaction_Customer  ON FinancialTransaction(CustomerId);

DO $$
BEGIN
	INSERT INTO Customer (CreditLimit)
	VALUES
		(1000 * 100),
		(800 * 100),
		(10000 * 100),
		(100000 * 100),
		(5000 * 100);
END;
$$;
