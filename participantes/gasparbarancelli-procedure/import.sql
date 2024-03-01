CREATE TABLE public.CLIENTE (
                                ID SERIAL PRIMARY KEY,
                                LIMITE INT,
                                SALDO INT DEFAULT 0
) WITH (autovacuum_enabled = false);

CREATE TABLE public.TRANSACAO (
                                  ID SERIAL PRIMARY KEY,
                                  CLIENTE_ID INT NOT NULL,
                                  VALOR INT NOT NULL,
                                  TIPO CHAR(1) NOT NULL,
                                  DESCRICAO VARCHAR(10) NOT NULL,
                                  DATA TIMESTAMP NOT NULL,
                                  FOREIGN KEY (CLIENTE_ID) REFERENCES public.CLIENTE(ID)
) WITH (autovacuum_enabled = false);

INSERT INTO public.CLIENTE (ID, LIMITE)
VALUES (1, 100000),
       (2, 80000),
       (3, 1000000),
       (4, 10000000),
       (5, 500000);


CREATE OR REPLACE PROCEDURE efetuar_transacao(
    IN clienteIdParam int,
    IN tipoParam varchar(1),
    IN valorParam int,
    IN descricaoParam varchar(10),
    OUT saldoRetorno int,
    OUT limiteRetorno int
)
LANGUAGE plpgsql
AS $$
DECLARE
cliente cliente%rowtype;
    novoSaldo int;
BEGIN

    IF tipoParam = 'd' THEN
        novoSaldo := valorParam * -1;
ELSE
        novoSaldo := valorParam;
END IF;

UPDATE cliente
SET saldo = saldo + novoSaldo
WHERE id = clienteIdParam
  AND (novoSaldo > 0 OR limite * -1 <= saldo + novoSaldo)
    RETURNING * INTO cliente;

IF NOT FOUND THEN
            RAISE EXCEPTION 'Cliente não possui limite';
END IF;

INSERT INTO transacao (cliente_id, valor, tipo, descricao, data)
VALUES (clienteIdParam, valorParam, tipoParam, descricaoParam, current_timestamp);

SELECT cliente.saldo, cliente.limite INTO saldoRetorno, limiteRetorno;
END;
$$;