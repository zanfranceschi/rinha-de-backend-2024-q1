
CREATE UNLOGGED TABLE public.cliente (
    id serial PRIMARY KEY,
    limite int NOT NULL,
    saldo_inicial int NOT NULL
);
 CREATE INDEX clientes_id_idx ON cliente (id);

INSERT INTO public.cliente (limite, saldo_inicial)
VALUES
(100000, 0),
(80000, 0),
(1000000, 0),
(10000000, 0),
(500000, 0);

CREATE UNLOGGED TABLE public.historico_cliente (
    id SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_transacoes_cliente_id ON public.historico_cliente (id_cliente);

ALTER TABLE ONLY public.historico_cliente
    ADD CONSTRAINT historico_cliente_fk FOREIGN KEY (id_cliente) REFERENCES cliente(id);
	
	
CREATE OR REPLACE FUNCTION ExecutarTransacao(id_cliente INTEGER, valor INTEGER, tipo CHAR, descricao TEXT)
RETURNS TABLE (limite INTEGER, saldo_inicial INTEGER) AS $$
DECLARE
    limiteAtual INTEGER;
    saldoAtual INTEGER;
BEGIN    
    SELECT cliente.limite, cliente.saldo_inicial INTO limiteAtual, saldoAtual FROM public.cliente WHERE id = id_cliente FOR UPDATE;

    IF tipo = 'd' THEN
        saldoAtual := saldoAtual - valor;
    ELSE
        saldoAtual := saldoAtual + valor;
    END IF;

    IF saldoAtual < 0 AND ABS(saldoAtual) > limiteAtual THEN
        RETURN;
    ELSE    
        INSERT INTO historico_cliente (id_cliente, valor, tipo, descricao, realizada_em)
        VALUES (id_cliente, valor, tipo, descricao, CURRENT_TIMESTAMP);

        UPDATE cliente SET saldo_inicial = saldoAtual WHERE id = id_cliente;

        RETURN QUERY SELECT limiteAtual, saldoAtual;
    END IF;
END;
$$ LANGUAGE plpgsql;


