--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.5 (Ubuntu 15.5-1.pgdg22.04+1)

-- Started on 2024-02-14 23:31:31 -03

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 16385)
-- Name: clients; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    "limit" integer DEFAULT 0 NOT NULL,
    current_balance integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.clients OWNER TO admin;

--
-- TOC entry 215 (class 1259 OID 16390)
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.clients ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cliente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 16391)
-- Name: transactions; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.transactions (
    value integer NOT NULL,
    type character(1) NOT NULL,
    description character varying,
    at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    client_id integer,
    id integer NOT NULL
);


ALTER TABLE public.transactions OWNER TO admin;

--
-- TOC entry 217 (class 1259 OID 16396)
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.transactions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3351 (class 0 OID 16385)
-- Dependencies: 214
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.clients (id, "limit", current_balance) FROM stdin;
2	80000	0
3	1000000	0
5	500000	0
4	10000000	0
1	100000	0
\.


--
-- TOC entry 3353 (class 0 OID 16391)
-- Dependencies: 216
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.transactions (value, type, description, at, client_id, id) FROM stdin;
\.


--
-- TOC entry 3360 (class 0 OID 0)
-- Dependencies: 215
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.cliente_id_seq', 5, true);


--
-- TOC entry 3361 (class 0 OID 0)
-- Dependencies: 217
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.transactions_id_seq', 1, false);


--
-- TOC entry 3204 (class 2606 OID 16398)
-- Name: clients clients_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pk PRIMARY KEY (id);


--
-- TOC entry 3207 (class 2606 OID 16400)
-- Name: transactions transactions_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pk PRIMARY KEY (id);


--
-- TOC entry 3205 (class 1259 OID 16426)
-- Name: transactions_client_id_index; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX transactions_client_id_index ON public.transactions USING btree (client_id);


--
-- TOC entry 3208 (class 2606 OID 16401)
-- Name: transactions transactions_client_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_client_id_fk FOREIGN KEY (client_id) REFERENCES public.clients(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2024-02-14 23:31:31 -03

--
-- PostgreSQL database dump complete
--

