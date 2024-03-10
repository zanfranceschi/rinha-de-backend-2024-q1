CREATE UNLOGGED TABLE public.CLIENTE (
                                ID SERIAL PRIMARY KEY,
                                LIMITE INT,
                                SALDO INT DEFAULT 0
) WITH (autovacuum_enabled = false);

CREATE UNLOGGED TABLE public.TRANSACAO (
                                  ID SERIAL PRIMARY KEY,
                                  CLIENTE_ID INT NOT NULL,
                                  VALOR INT NOT NULL,
                                  TIPO CHAR(1) NOT NULL,
                                  DESCRICAO VARCHAR(10) NOT NULL,
                                  DATA TIMESTAMP NOT NULL
) WITH (autovacuum_enabled = false);

CREATE INDEX IDX_TRANSACAO_CLIENTE ON TRANSACAO (CLIENTE_ID ASC);

INSERT INTO public.CLIENTE (ID, LIMITE)
VALUES (1, 100000),
       (2, 80000),
       (3, 1000000),
       (4, 10000000),
       (5, 500000);


CREATE OR REPLACE FUNCTION efetuar_transacao(
    clienteIdParam int,
    tipoParam varchar(1),
    valorParam int,
    descricaoParam varchar(10)
)
RETURNS TABLE (saldoRetorno int, limiteRetorno int) AS $$
DECLARE
    cliente cliente%rowtype;
    novoSaldo int;
    numeroLinhasAfetadas int;
BEGIN

    IF tipoParam = 'd' THEN
            novoSaldo := valorParam * -1;
    ELSE
            novoSaldo := valorParam;
    END IF;

    UPDATE cliente SET saldo = saldo + novoSaldo
    WHERE id = clienteIdParam AND (novoSaldo > 0 OR limite * -1 <= saldo + novoSaldo)
        RETURNING * INTO cliente;

    GET DIAGNOSTICS numeroLinhasAfetadas = ROW_COUNT;

    IF numeroLinhasAfetadas = 0 THEN
            RAISE EXCEPTION 'Cliente nao possui limite';
    END IF;

    INSERT INTO transacao (cliente_id, valor, tipo, descricao, data)
    VALUES (clienteIdParam, valorParam, tipoParam, descricaoParam, current_timestamp);


    RETURN QUERY SELECT cliente.saldo, cliente.limite;
END;
$$ LANGUAGE plpgsql;