--
-- Name: clientes; Type: TABLE; Schema: public; Owner: rinha
--

CREATE TABLE public.clientes (
    id smallint NOT NULL,
    limite integer,
    saldo integer,
    CONSTRAINT saldo_check CHECK (((limite + saldo) > 0))
);


ALTER TABLE public.clientes OWNER TO rinha;

--
-- Name: transacoes; Type: TABLE; Schema: public; Owner: rinha
--

CREATE TABLE public.transacoes (
    clientes_id integer NOT NULL,
    data timestamp with time zone NOT NULL,
    tipo character varying(1),
    descricao text,
    --descricao character varying(10),
    valor integer,
    CONSTRAINT tipo_check CHECK (tipo in ('c','d')),
    CONSTRAINT tipo_descricao CHECK (coalesce(descricao, '') <> ''),
    CONSTRAINT length_descricao CHECK (char_length(descricao)<=10)
);


ALTER TABLE public.transacoes OWNER TO rinha;

--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: rinha
--

INSERT INTO public.clientes VALUES (3, 1000000, 0);
INSERT INTO public.clientes VALUES (1, 100000, 0);
INSERT INTO public.clientes VALUES (2, 80000, 0);
INSERT INTO public.clientes VALUES (4, 10000000, 0);
INSERT INTO public.clientes VALUES (5, 500000, 0);


--
-- Data for Name: transacoes; Type: TABLE DATA; Schema: public; Owner: rinha
--



--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: rinha
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: transacoes transacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: rinha
--

ALTER TABLE ONLY public.transacoes
    ADD CONSTRAINT transacoes_pkey PRIMARY KEY (clientes_id, data, tipo);


--
-- Name: transacoes transacoes_fkey_clientes_id; Type: FK CONSTRAINT; Schema: public; Owner: rinha
--

ALTER TABLE ONLY public.transacoes
    ADD CONSTRAINT transacoes_fkey_clientes_id FOREIGN KEY (clientes_id) REFERENCES public.clientes(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

