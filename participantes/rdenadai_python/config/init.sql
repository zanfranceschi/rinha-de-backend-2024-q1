CREATE TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL
);

CREATE TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE saldos (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	CONSTRAINT fk_clientes_saldos_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TYPE saldo_result AS (
	efetuado boolean,
    limite integer,
    saldo integer
);

CREATE OR REPLACE FUNCTION atualiza_saldo(uclient_id integer, uvalor integer, utipo char, udescricao varchar) RETURNS saldo_result AS $$
DECLARE
	ctotal integer;
	climite integer;
	novo_saldo integer;
	limite integer;
	saldo integer;
	result saldo_result;
BEGIN
	result.efetuado := false;

	SELECT c.limite as limite, s.valor as total
	INTO climite, ctotal
	FROM clientes c 
	JOIN saldos s on c.id = s.cliente_id 
	WHERE c.id = uclient_id FOR UPDATE;
	
	IF utipo = 'd' THEN
		novo_saldo := ctotal - uvalor;
		IF novo_saldo < -climite THEN
			result.efetuado := true;
		END IF;
	ELSE
		novo_saldo := ctotal + uvalor;
	END IF;

	IF result.efetuado = false THEN
		UPDATE saldos SET valor = novo_saldo WHERE cliente_id = uclient_id;
		INSERT INTO transacoes (cliente_id, valor, tipo, descricao) VALUES (uclient_id, uvalor, utipo, udescricao);
	END IF;

	result.limite := climite;
    result.saldo := novo_saldo;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
	INSERT INTO clientes (nome, limite)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);
	
	INSERT INTO saldos (cliente_id, valor)
		SELECT id, 0 FROM clientes;
END;
$$;