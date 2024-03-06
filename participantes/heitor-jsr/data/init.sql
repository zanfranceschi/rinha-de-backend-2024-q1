ALTER SYSTEM SET
 max_connections = '300';
ALTER SYSTEM SET
 shared_buffers = '35MB';
ALTER SYSTEM SET
 effective_cache_size = '105MB';
ALTER SYSTEM SET
 maintenance_work_mem = '8960kB';
ALTER SYSTEM SET
 checkpoint_completion_target = '0.9';
ALTER SYSTEM SET
 wal_buffers = '1075kB';
ALTER SYSTEM SET
 default_statistics_target = '100';
ALTER SYSTEM SET
 random_page_cost = '1.1';
ALTER SYSTEM SET
 effective_io_concurrency = '200';
ALTER SYSTEM SET
 work_mem = '64kB';
ALTER SYSTEM SET
 huge_pages = 'off';
ALTER SYSTEM SET
 min_wal_size = '2GB';
ALTER SYSTEM SET
 max_wal_size = '8GB';

CREATE SEQUENCE public.client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.client_id_seq OWNER TO postgres;

SET default_tablespace = '';
SET default_table_access_method = heap;

CREATE TABLE public.clientes (
    id integer DEFAULT nextval('public.client_id_seq'::regclass) NOT NULL,
    limite integer,
    saldo integer,
    nome varchar(255),
    PRIMARY KEY (id)
);

ALTER TABLE public.clientes OWNER TO postgres;

CREATE TABLE public.saldo (
    total integer,
    data_extrato timestamp without time zone default now(),
    limite integer
);

ALTER TABLE public.saldo OWNER TO postgres;

CREATE TABLE public.transacoes (
    id integer DEFAULT nextval('public.client_id_seq'::regclass) NOT NULL,
    PRIMARY KEY (id),
    valor integer,
    tipo varchar(255),
    descricao varchar(255),
    realizada_em timestamp without time zone default now(),
	cliente_id INTEGER NOT NULL,
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

ALTER TABLE public.transacoes OWNER TO postgres;

INSERT INTO public.clientes (nome, limite, saldo) VALUES
		('o barato sai caro', 1000 * 100, 0),
		('zan corp ltda', 800 * 100, 0),
		('les cruders', 10000 * 100, 0),
		('padaria joia de cocaia', 100000 * 100, 0),
		('kid mais', 5000 * 100, 0);
