CREATE UNLOGGED TABLE client (
	id SERIAL PRIMARY KEY,
	lim INTEGER NOT NULL,
	bal INTEGER NOT NULL DEFAULT 0,
	name VARCHAR(50) NOT NULL,
	CONSTRAINT balance_limit CHECK (bal >= lim * -1)
);

CREATE UNLOGGED TABLE transaction (
	id SERIAL PRIMARY KEY,
	cid INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	type CHAR(1) NOT NULL,
	c_at TIMESTAMP NOT NULL DEFAULT NOW(),
	descr VARCHAR(10) NOT NULL,
	CONSTRAINT fk_client_transaction_id
		FOREIGN KEY (cid) REFERENCES client(id)
);

CREATE INDEX idx_transaction_cid ON transaction (cid);

INSERT INTO client (name, lim)
VALUES
	('o barato sai caro', 1000 * 100),
	('zan corp ltda', 800 * 100),
	('les cruders', 10000 * 100),
	('padaria joia de cocaia', 100000 * 100),
	('kid mais', 5000 * 100);
