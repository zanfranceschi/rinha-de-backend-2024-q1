CREATE TABLE clients (
	id SERIAL PRIMARY KEY,
	withdraw_limit INTEGER NOT NULL,
	balance INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE transaction (
	id SERIAL PRIMARY KEY,
	client_id INTEGER NOT NULL,
	value INTEGER NOT NULL,
	type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_client_transaction FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE INDEX idx_client_id  ON transaction (client_id);
CREATE INDEX idx_created_at_desc ON transaction (created_at DESC);

CREATE OR REPLACE FUNCTION update_balance_and_insert_transaction( _clientId INT, _value INT, _type CHAR, _description VARCHAR(10)) RETURNS TABLE(wl INT, fb INT) AS $$ BEGIN

        SELECT balance, withdraw_limit INTO fb, wl FROM clients WHERE id = _clientId FOR UPDATE;

        IF (fb + _value) < -wl AND _type = 'd' THEN
            RAISE NOTICE 'Insufficient funds';
        ELSE
            UPDATE clients SET balance = balance + _value WHERE id = _clientId RETURNING balance INTO fb; 
            INSERT INTO transaction (client_id, value, type, description) VALUES (_clientId, ABS(_value), _type, _description);
            RETURN NEXT;
        END IF;

END; $$ LANGUAGE plpgsql;
-- Insert placeholder values
INSERT INTO clients (id, withdraw_limit, balance) VALUES
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);
