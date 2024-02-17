CREATE TABLE IF NOT EXISTS clientes (
    id INT PRIMARY KEY,
    limite BIGINT,
    saldo BIGINT
);

CREATE INDEX idx_clientes_id ON clientes (id);

CREATE TABLE IF NOT EXISTS transacoes
(
    id SERIAL PRIMARY KEY,
    cliente_id integer,
    valor integer,
    tipo character varying,
    descricao character varying,
    realizada_em timestamp without time zone
);

CREATE INDEX IF NOT EXISTS idx_transacoes_cliente_id
    ON public.transacoes USING btree
    (cliente_id ASC NULLS LAST)
    TABLESPACE pg_default;

INSERT INTO clientes (id, limite, saldo)
SELECT 1, 1000 * 100, 0 WHERE NOT EXISTS (SELECT 1 FROM clientes WHERE id = 1);
INSERT INTO clientes (id, limite, saldo)
SELECT 2, 800 * 100, 0 WHERE NOT EXISTS (SELECT 1 FROM clientes WHERE id = 2);
INSERT INTO clientes (id, limite, saldo)
SELECT 3, 10000 * 100, 0 WHERE NOT EXISTS (SELECT 1 FROM clientes WHERE id = 3);
INSERT INTO clientes (id, limite, saldo)
SELECT 4, 100000 * 100, 0 WHERE NOT EXISTS (SELECT 1 FROM clientes WHERE id = 4);
INSERT INTO clientes (id, limite, saldo)
SELECT 5, 5000 * 100, 0 WHERE NOT EXISTS (SELECT 1 FROM clientes WHERE id = 5);