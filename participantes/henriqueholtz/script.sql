CREATE TABLE Customers (
   CustomerId SERIAL PRIMARY KEY,
   MaxLimit INTEGER NOT NULL
);

CREATE TABLE Transactions (
   TransactionId SERIAL PRIMARY KEY,
   CustomerId INTEGER NOT NULL,
   Value INTEGER NOT NULL,
   IsCredit BOOLEAN NOT NULL,
   Date TIMESTAMP NOT NULL,
   Description VARCHAR(10) NOT NULL
);

INSERT INTO Customers (MaxLimit) 
    VALUES 
    (100000), 
    (80000), 
    (1000000),
    (10000000), 
    (500000)