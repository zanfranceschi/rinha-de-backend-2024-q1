DROP TABLE IF EXISTS transacoes;
DROP TABLE IF EXISTS clientes;

CREATE UNLOGGED TABLE clientes (
    id     SMALLSERIAL PRIMARY KEY,
    limite INT NOT NULL,
    saldo  BIGINT NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transacoes (
   id           SERIAL PRIMARY KEY,
   cliente_id   SMALLINT NOT NULL,
   valor        BIGINT NOT NULL,
   tipo         CHAR(1) NOT NULL,
   descricao    TEXT NOT NULL,
   data_hora TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()::timestamp,
   CONSTRAINT fk_transacao_cliente FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);

CREATE INDEX ON transacoes (cliente_id, data_hora DESC);
CREATE UNIQUE INDEX ON clientes (id);


INSERT INTO clientes(id, limite, saldo) VALUES 
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);


CREATE OR REPLACE FUNCTION public.envio_transacao(
    id_cliente INT,
    descricao TEXT,
    tipo TEXT,
    valor BIGINT
) RETURNS JSON AS
$$
DECLARE
    saldoAtual BIGINT;
    novoSaldo BIGINT;
    id_c INT;
    l INT;
BEGIN
    SELECT id INTO id_c FROM clientes WHERE id = id_cliente;
    SELECT saldo INTO saldoAtual FROM clientes WHERE id = id_cliente FOR UPDATE;
    SELECT limite INTO l FROM clientes WHERE id = id_cliente;

    IF id_c ISNULL THEN
        RETURN id_c;
    END IF;

    IF tipo = 'c' THEN
        novoSaldo := saldoAtual + valor;
    ELSE
        novoSaldo := saldoAtual - valor;
    END IF;
   
    IF novoSaldo >= -l THEN
        UPDATE clientes SET saldo = novoSaldo WHERE id = id_cliente;
        INSERT INTO transacoes(cliente_id, valor, tipo, descricao) VALUES (id_cliente, valor, tipo, descricao);
        RETURN json_build_object('id', id_cliente, 'limite', l, 'saldo', novoSaldo);
    ELSE
        RAISE EXCEPTION 'O cliente não tem limite para executar essa transação.'; 
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.get_transacoes(
    id_cliente INT
) RETURNS JSON AS
$$
DECLARE
	cliente JSON;
	transacoes JSON;
BEGIN	
	SELECT to_jsonb(c) INTO cliente FROM clientes as c WHERE c.id = id_cliente FOR UPDATE;
   
    IF cliente ISNULL THEN
	  RAISE EXCEPTION 'Não existe um cliente com o id informado'; 
    ELSE
		SELECT jsonb_agg(to_jsonb(transacoes_by_user)) INTO transacoes
		FROM (
				SELECT * FROM transacoes AS t
			  	WHERE t.cliente_id = id_cliente
			  	ORDER BY t.data_hora DESC
			    LIMIT 10 FOR UPDATE
			 ) AS transacoes_by_user;
		
		RETURN json_build_object('saldo', cliente, 'transacoes', transacoes);
    END IF;
END;
$$ LANGUAGE plpgsql;