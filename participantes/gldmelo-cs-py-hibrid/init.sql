CREATE TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL,
	saldo INTEGER NOT NULL DEFAULT 0,
	CONSTRAINT valida_saldo CHECK (saldo >= (- limite))
);

CREATE TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
	--CONSTRAINT fk_clientes_transacoes_id FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

DO $$
BEGIN
	INSERT INTO clientes (nome, limite)
	VALUES
		('Fulano', 1000 * 100),
		('Beltrano', 800 * 100),
		('Cicrano', 10000 * 100),
		('Deutrano', 100000 * 100),
		('Eutrano', 5000 * 100);
END;
$$;

CREATE OR REPLACE FUNCTION inserir_transacao_credito_e_retornar_saldo (
	clienteid_in int,
	valor_in int,
	descricao_in varchar(10)
)
RETURNS int
AS $$
	DECLARE saldo_atualizado int;
BEGIN	
	INSERT INTO "transacoes" ("cliente_id", "valor", "tipo", "descricao") values (clienteid_in, valor_in, 'c', descricao_in);
	UPDATE "clientes" set "saldo" = "saldo" + valor_in where "id" = clienteid_in RETURNING "saldo" into saldo_atualizado;
    return saldo_atualizado;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inserir_transacao_debito_e_retornar_saldo (
	clienteid_in int,
	valor_in int,
	descricao_in varchar(10)
)
RETURNS int
AS $$
	DECLARE saldo_atualizado int;
BEGIN	
    UPDATE "clientes" set "saldo" = "saldo" - valor_in where "id" = clienteid_in and "saldo" - valor_in >= ("limite" * -1) returning "saldo" into saldo_atualizado;

    IF saldo_atualizado IS NOT NULL THEN
	    INSERT INTO "transacoes" ("cliente_id", "valor", "tipo", "descricao") values (clienteid_in, valor_in, 'd', descricao_in);
    END IF;

    RETURN saldo_atualizado;
END;
$$ LANGUAGE plpgsql;

CREATE INDEX idx_transacoes_on_cliente_id_realizado_em ON transacoes USING btree (cliente_id, realizada_em);
