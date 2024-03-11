--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5 (Debian 15.5-1.pgdg120+1)
-- Dumped by pg_dump version 15.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA IF NOT EXISTS public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dados_bancarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dados_bancarios (
    id_conta integer NOT NULL,
    limite bigint NOT NULL,
    nome_cliente text NOT NULL
);


ALTER TABLE public.dados_bancarios OWNER TO postgres;

--
-- Name: saldos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saldos (
    id_conta integer NOT NULL,
    saldo bigint NOT NULL
);


ALTER TABLE public.saldos OWNER TO postgres;

--
-- Name: transacoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transacoes (
    id bigint NOT NULL,
    id_conta integer NOT NULL,
    tipo_operacao "char" NOT NULL,
    valor bigint NOT NULL,
    descricao text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.transacoes OWNER TO postgres;

--
-- Name: transacoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transacoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transacoes_id_seq OWNER TO postgres;

--
-- Name: transacoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transacoes_id_seq OWNED BY public.transacoes.id;


--
-- Name: transacoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transacoes ALTER COLUMN id SET DEFAULT nextval('public.transacoes_id_seq'::regclass);


--
-- Data for Name: dados_bancarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dados_bancarios VALUES (1, 100000, 'o barato sai caro');
INSERT INTO public.dados_bancarios VALUES (2, 80000, 'zan corp ltda');
INSERT INTO public.dados_bancarios VALUES (3, 1000000, 'les cruders');
INSERT INTO public.dados_bancarios VALUES (4, 10000000, 'padaria joia de cocaia');
INSERT INTO public.dados_bancarios VALUES (5, 500000, 'kid mais');


--
-- Data for Name: saldos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.saldos VALUES (1, 0);
INSERT INTO public.saldos VALUES (2, 0);
INSERT INTO public.saldos VALUES (3, 0);
INSERT INTO public.saldos VALUES (4, 0);
INSERT INTO public.saldos VALUES (5, 0);



--
-- Name: dados_bancarios dados_bancarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dados_bancarios
    ADD CONSTRAINT dados_bancarios_pkey PRIMARY KEY (id_conta);


--
-- Name: transacoes operacao; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.transacoes
    ADD CONSTRAINT operacao CHECK (((tipo_operacao = 'c'::"char") OR (tipo_operacao = 'd'::"char"))) NOT VALID;


--
-- Name: saldos saldos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saldos
    ADD CONSTRAINT saldos_pkey PRIMARY KEY (id_conta);


--
-- Name: transacoes transacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transacoes
    ADD CONSTRAINT transacoes_pkey PRIMARY KEY (id);


--
-- Name: transacoes id_conta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transacoes
    ADD CONSTRAINT id_conta FOREIGN KEY (id_conta) REFERENCES public.dados_bancarios(id_conta) ON UPDATE RESTRICT ON DELETE RESTRICT NOT VALID;


--
-- Name: saldos saldos_contas; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saldos
    ADD CONSTRAINT saldos_contas FOREIGN KEY (id_conta) REFERENCES public.dados_bancarios(id_conta) NOT VALID;


--
-- PostgreSQL database dump complete
--

