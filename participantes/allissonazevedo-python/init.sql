-- create clientes table

CREATE UNLOGGED TABLE IF NOT EXISTS clientes (
   id SMALLINT PRIMARY KEY NOT NULL,
   limite INTEGER NOT NULL,
   saldo INTEGER NOT NULL,
   ultimas_transacoes JSONB not null default '[]'::jsonb,
   CONSTRAINT limite_minimo CHECK (saldo > limite)
);

-- insert clientes

INSERT INTO clientes (id, limite, saldo)
VALUES
    (1, -100000, 0),
    (2, -80000, 0),
    (3, -1000000, 0),
    (4, -10000000, 0),
    (5, -500000, 0),
    (9999, -10000000, 0);


-- add_transaction function
CREATE OR REPLACE FUNCTION add_transaction(client_id INTEGER, transaction JSONB)
RETURNS JSONB AS $$
DECLARE
   novosaldo INTEGER;
   cliente RECORD;
BEGIN
   IF transaction ->> 'tipo' = 'c' THEN
      novosaldo := (transaction ->> 'valor')::INTEGER;
   ELSIF transaction ->> 'tipo' = 'd' THEN
      novosaldo := -(transaction ->> 'valor')::INTEGER;
   END IF;

   UPDATE clientes
      SET
         saldo = saldo + novosaldo,
         ultimas_transacoes = jsonb_path_query_array(jsonb_insert(ultimas_transacoes,'{0}', transaction), '$[0 to 9]')
      WHERE id = client_id
      RETURNING * INTO cliente;

   IF NOT FOUND THEN
      RAISE EXCEPTION 'cliente_not_found';
   END IF;

   RETURN jsonb_build_object('limite', ABS(cliente.limite), 'saldo', cliente.saldo);

END;
$$ LANGUAGE plpgsql;
