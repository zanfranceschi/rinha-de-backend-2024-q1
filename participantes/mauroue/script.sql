-- Coloque scripts iniciais aqui

CREATE UNLOGGED TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL,
        saldo INTEGER DEFAULT 0
);

CREATE UNLOGGED TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao text NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

DO $$
BEGIN
	INSERT INTO clientes (nome, limite)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);

END;
$$;

-- criando indices
CREATE INDEX indice_transacoes_1 ON transacoes (cliente_id, realizada_em DESC) WHERE cliente_id = 1;
CREATE INDEX indice_transacoes_2 ON transacoes (cliente_id, realizada_em DESC) WHERE cliente_id = 2;
CREATE INDEX indice_transacoes_3 ON transacoes (cliente_id, realizada_em DESC) WHERE cliente_id = 3;
CREATE INDEX indice_transacoes_4 ON transacoes (cliente_id, realizada_em DESC) WHERE cliente_id = 4;
CREATE INDEX indice_transacoes_5 ON transacoes (cliente_id, realizada_em DESC) WHERE cliente_id = 5;

-- criando gatilhos para atualizar o saldo
CREATE OR REPLACE FUNCTION reconcile_amount_trigger_function()
RETURNS TRIGGER LANGUAGE plpgsql AS $$

DECLARE
	oldsaldo INT;
	oldlimite INT;

BEGIN

	SELECT saldo, limite INTO oldsaldo, oldlimite
	FROM clientes c 
	WHERE id = NEW.cliente_id;

	IF NEW.tipo = 'd' and new.valor > 0 THEN
		NEW.valor = NEW.valor * -1;
		IF oldsaldo + NEW.valor + oldlimite < 0 THEN
			RAISE EXCEPTION 'limite excedido';
		END IF;
	END IF;

	UPDATE clientes SET saldo = saldo + NEW.valor WHERE id = NEW.cliente_id AND SALDO + NEW.VALOR + oldlimite > 0;
RETURN NEW;

END;

$$;

CREATE TRIGGER reconcile_amount_trigger
AFTER INSERT ON transacoes
FOR EACH ROW
EXECUTE FUNCTION reconcile_amount_trigger_function();

