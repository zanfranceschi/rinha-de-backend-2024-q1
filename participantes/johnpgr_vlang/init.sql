CREATE UNLOGGED TABLE IF NOT EXISTS cliente (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL,
	saldo INTEGER NOT NULL DEFAULT 0,
	ultimas_transacoes JSONB NOT NULL DEFAULT '[]'::JSONB
);

DO $$
BEGIN
	INSERT INTO cliente (nome, limite)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);
END;
$$;

CREATE OR REPLACE FUNCTION add_transacao(cliente_id INTEGER, transacao JSONB)
RETURNS JSONB AS $$
DECLARE
   valor_transacao INTEGER;
   cliente RECORD;
BEGIN
   IF transacao ->> 'tipo' = 'c' THEN
      valor_transacao := (transacao ->> 'valor')::INTEGER;
   ELSIF transacao ->> 'tipo' = 'd' THEN
      valor_transacao := -(transacao ->> 'valor')::INTEGER;
   END IF;

   UPDATE cliente
      SET
         saldo = saldo + valor_transacao,
         ultimas_transacoes = jsonb_path_query_array(jsonb_insert(ultimas_transacoes,'{0}', transacao), '$[0 to 9]')
      WHERE id = cliente_id
      AND valor_transacao + saldo + limite >= 0
      RETURNING limite as limite, saldo as saldo INTO cliente;

   IF NOT FOUND THEN
      RETURN '{}'::JSONB;
   END IF;

   RETURN jsonb_build_object('limite', cliente.limite, 'saldo', cliente.saldo);
END;
$$ LANGUAGE plpgsql;
