CREATE UNLOGGED TABLE clientes (
                                   id SMALLSERIAL PRIMARY KEY,
                                   limite INTEGER,
                                   valor INTEGER
);

CREATE UNLOGGED TABLE transacoes (
--          id SERIAL PRIMARY KEY,
--          cliente_id INTEGER NOT NULL,
--          valor INTEGER NOT NULL,
--          tipo CHAR(1) NOT NULL,
--          descricao VARCHAR(10) NOT NULL,
--          realizada_em TIMESTAMP NOT NULL DEFAULT NOW()

                                     id SERIAL PRIMARY KEY,
                                     cliente_id SMALLINT,
                                     valor INTEGER,
                                     tipo CHAR(1),
                                     descricao VARCHAR(10),
                                     realizada_em TIMESTAMP
--          CONSTRAINT fk_clientes_transacoes_id
--              FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX idx_transacoes_cliente_id ON transacoes(cliente_id, realizada_em);

INSERT INTO clientes (id, limite, valor)
VALUES
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);


CREATE EXTENSION IF NOT EXISTS pg_prewarm;
SELECT pg_prewarm('clientes');

-- create function make_transaction(transaction_client_id integer, transaction_value integer, transaction_type character, transaction_description text)
--     returns TABLE(valor integer, limite integer)
--     language plpgsql
-- as
-- $$
-- DECLARE
--     client RECORD;
-- BEGIN
--     -- Select valor and limite from clientes
--     SELECT INTO client clientes.valor, clientes.limite FROM clientes WHERE id = transaction_client_id FOR UPDATE;
--
--     -- Update client value
--     client.valor := client.valor + transaction_value;
--
--     -- Check if the new balance is less than the negative limit
--     IF client.valor < -client.limite THEN
--         RAISE EXCEPTION 'saldo insuficiente';
--     END IF;
--
--     -- Update clientes
--     UPDATE clientes SET valor = client.valor WHERE id = transaction_client_id;
--
--     -- Insert into transacoes
--     INSERT INTO transacoes(valor, cliente_id, tipo, descricao, realizada_em)
--     VALUES (transaction_value, transaction_client_id, transaction_type, transaction_description, NOW());
--
--     -- Return the updated client values
--     RETURN QUERY SELECT client.valor, client.limite;
-- END; $$;