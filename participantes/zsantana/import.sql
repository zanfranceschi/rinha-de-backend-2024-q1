-- Define algumas configurações iniciais
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


-- Altera o esquema padrão para 'public'
SELECT pg_catalog.set_config('search_path', 'public', false);

CREATE SEQUENCE public.transacao_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE public.cliente_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE public.saldocliente_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;


-- Criação das tabelas
CREATE TABLE public.cliente (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL
);

CREATE TABLE public.saldocliente (
    id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	CONSTRAINT fk_clientes_saldos_id FOREIGN KEY (cliente_id) REFERENCES public.cliente(id)
);

CREATE TABLE public.transacao (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL,
    CONSTRAINT fk_clientes_transacoes_id FOREIGN KEY (cliente_id) REFERENCES public.cliente(id)
);

ALTER TABLE public.transacao ALTER COLUMN id SET DEFAULT nextval('transacao_id_seq');


-- Criação de índice
CREATE INDEX transacoes_index ON public.transacao (id desc NULLS FIRST) INCLUDE (valor, tipo, descricao, realizada_em);


-- Inserção de dados nas tabelas
INSERT INTO public.cliente (nome, limite) VALUES
    ('MATEUS', 1000 * 100),
    ('MARCOS',800 * 100),
    ('LUCAS', 10000 * 100),
    ('JOAO', 100000 * 100),
    ('PAULO', 5000 * 100);

INSERT INTO saldocliente (cliente_id, valor)
SELECT id, 0 FROM cliente;

CREATE VIEW v_checa_saldo_cliente AS
SELECT 
    c.id,
    c.nome,
    c.limite,
    s.valor AS saldo_atual,
    (COALESCE(valor_credito, 0) - COALESCE(valor_debito, 0)) AS saldo_calculado,
    s.valor - (COALESCE(valor_credito, 0) - COALESCE(valor_debito, 0)) AS dif_saldo,
    COALESCE(tot_c, 0) AS tot_transacao_c,
    COALESCE(tot_d, 0) AS tot_transacao_d
FROM
    public.cliente c
JOIN
    public.saldocliente s ON c.id = s.cliente_id
LEFT JOIN (
    SELECT 
        cliente_id,
        COUNT(1) AS tot_c,
        SUM(valor) AS valor_credito
    FROM 
        public.transacao
    WHERE 
        tipo = 'c'
    GROUP BY 
        cliente_id
) AS total_credito ON c.id = total_credito.cliente_id
LEFT JOIN (
    SELECT 
        cliente_id,
        COUNT(1) AS tot_d,
        SUM(valor) AS valor_debito
    FROM 
        public.transacao
    WHERE 
        tipo = 'd'
    GROUP BY 
        cliente_id
) AS total_debito ON c.id = total_debito.cliente_id
ORDER BY 
    c.id;

