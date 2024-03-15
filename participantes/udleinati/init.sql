CREATE UNLOGGED TABLE cliente (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(10) NOT NULL,
	limite INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transacao (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE UNLOGGED TABLE saldo (
  cliente_id INTEGER NOT NULL PRIMARY KEY,
  valor BIGINT NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

-- SALDO PROCEDURE CONTROL
CREATE OR REPLACE FUNCTION reconcile_saldo()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
DECLARE
	should_continue BOOLEAN;
BEGIN
  CASE WHEN NEW.tipo = 'd' THEN
	 SELECT 
		CASE WHEN x.limite + (SELECT b.valor-NEW.valor FROM saldo b WHERE b.cliente_id=x.id) < 0 THEN
			FALSE
		ELSE
			TRUE
		END INTO should_continue
	FROM cliente x WHERE x.id=NEW.cliente_id;

	CASE WHEN should_continue IS FALSE THEN
		RAISE EXCEPTION 'No limit';
	ELSE
		-- do nothing
	END CASE;
  ELSE
  	-- do nothing
  END CASE;

  INSERT INTO saldo AS s (cliente_id, valor)
  VALUES (
  	NEW.cliente_id,
  	CASE WHEN NEW.tipo = 'c' THEN NEW.valor ELSE NEW.valor * -1 END
  )
  ON CONFLICT (cliente_id) DO
  UPDATE SET valor = s.valor+EXCLUDED.valor;
  RETURN NEW;
END;
$$;

CREATE TRIGGER reconcile_saldo
AFTER INSERT
ON transacao
FOR EACH ROW
EXECUTE PROCEDURE reconcile_saldo();

-- POPULATE
DO $$
BEGIN
	INSERT INTO cliente (id, nome, limite)
	VALUES
		(1, 'cliente 1', 1000 * 100),
		(2, 'cliente 2', 800 * 100),
		(3, 'cliente 3', 10000 * 100),
		(4, 'cliente 4', 100000 * 100),
		(5, 'cliente 5', 5000 * 100);
END;
$$;

-- JAMAIS faça isso em produção. Vá para um elasticsearch.
CREATE INDEX idx_transacao_clientid_1 ON transacao (realizada_em DESC) WHERE cliente_id=1;
CREATE INDEX idx_transacao_clientid_2 ON transacao (realizada_em DESC) WHERE cliente_id=2;
CREATE INDEX idx_transacao_clientid_3 ON transacao (realizada_em DESC) WHERE cliente_id=3;
CREATE INDEX idx_transacao_clientid_4 ON transacao (realizada_em DESC) WHERE cliente_id=4;
CREATE INDEX idx_transacao_clientid_5 ON transacao (realizada_em DESC) WHERE cliente_id=5;
