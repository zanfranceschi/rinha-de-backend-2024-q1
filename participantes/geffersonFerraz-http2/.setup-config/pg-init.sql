
CREATE TABLE public.clientes (
	id serial NOT NULL,
	saldo int8 NOT NULL,
	limite int8 NOT NULL,
	CONSTRAINT clientes_pkey PRIMARY KEY (id)
);


CREATE TABLE transactions (
	id serial NOT NULL,
	id_cliente int8 NOT NULL,
	tipo_transaction varchar(1) NOT NULL,
	valor int8 NOT NULL,
	description varchar(10) NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT transactions_pkey PRIMARY KEY (id)
);

ALTER TABLE public.transactions ADD CONSTRAINT transactions_id_client FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE;

CREATE INDEX transactions_id_cliente_idx ON public.transactions USING btree (id_cliente, id);

-- CREATE OR REPLACE FUNCTION get_client_transactions(client_id INT8)
-- RETURNS TABLE (
--     saldo int8,
--     limite int8,
--     valor int8,
--     tipo_transaction VARCHAR,
--     description VARCHAR,
--     created_at TIMESTAMP
-- ) AS $$
-- BEGIN
--     RETURN QUERY
--     SELECT c.saldo, c.limite, t.valor, t.tipo_transaction, t.description, t.created_at
--     FROM clientes c
--     JOIN transactions t ON t.id_cliente = c.id
--     WHERE c.id = client_id
--     ORDER BY t.id DESC
--     LIMIT 10;
--     IF NOT FOUND THEN
--         RETURN QUERY
--         SELECT c.saldo, c.limite,NULL::INT8, NULL::VARCHAR, NULL::VARCHAR, NULL::TIMESTAMP
--         FROM clientes c
--         WHERE c.id = client_id;
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;

INSERT INTO
    clientes (id, saldo, limite)
VALUES
    (1, 0, 100000),
    (2, 0, 80000),
    (3, 0, 1000000),
    (4, 0, 10000000),
    (5, 0, 500000);
    
   