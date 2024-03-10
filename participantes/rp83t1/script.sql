	CREATE TABLE customers ( 
		id SERIAL PRIMARY KEY, 
		name VARCHAR (40) NOT NULL, 
		account_limit INTEGER DEFAULT 0, 
		balance INTEGER DEFAULT 0,
		datetime timestamp DEFAULT current_timestamp );
		
	CREATE INDEX customers_index_1 ON customers ( id );		

	INSERT INTO customers (name, account_limit)
	  VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);
		

	CREATE TABLE transactions ( 
		id SERIAL PRIMARY KEY, 
		customer_id INTEGER REFERENCES customers(id),
		value INTEGER, 
		type CHAR(1) NOT NULL, 
		description VARCHAR (10) NOT NULL, 
		datetime timestamp DEFAULT current_timestamp);

	CREATE INDEX transactions_index_1 ON transactions ( 
		customer_id, 
		datetime DESC );