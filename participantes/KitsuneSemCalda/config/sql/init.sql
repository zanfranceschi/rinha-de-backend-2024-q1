CREATE TABLE IF NOT EXISTS clientes (
	id SERIAL PRIMARY KEY,
	limite INT NOT NULL CHECK (limite >= 0),
	saldo INT NOT NULL CHECK (saldo >= 0)
);


CREATE TABLE IF NOT EXISTS transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INT NOT NULL,
	valor INT NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL,
	FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE OR REPLACE FUNCTION validate_transaction()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.valor < 0 OR LENGTH(NEW.descricao) < 1 OR LENGTH(NEW.descricao) > 10 OR (NEW.tipo != 'c' AND NEW.tipo != 'd') THEN
        RAISE EXCEPTION 'Invalid Transaction';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_transaction_trigger
BEFORE INSERT ON transacoes
FOR EACH ROW
EXECUTE FUNCTION validate_transaction();


INSERT INTO clientes (id, limite, saldo) VALUES
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);
