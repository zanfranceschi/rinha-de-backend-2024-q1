CREATE UNLOGGED TABLE cliente
(
    id     INT PRIMARY KEY,
    limites INT NOT NULL,
    saldos  INT NOT NULL
);

INSERT INTO cliente (id, limites, saldos)
VALUES (1, 100000, 0),
       (2, 80000, 0),
       (3, 1000000, 0),
       (4, 10000000, 0),
       (5, 500000, 0);

CREATE UNLOGGED TABLE TRANSACAO
(
    ID           SERIAL      PRIMARY KEY,
    ID_CLIENTE   INT         NOT NULL,
    VALOR        INT         NOT NULL,
    TIPO         VARCHAR(1)  NOT NULL,
    DESCRICAO    VARCHAR(10) NOT NULL,
    REALIZADA_EM TIMESTAMP   NOT NULL
);

CREATE INDEX idx_transacao_id_cliente ON transacao (id_cliente);
CREATE INDEX idx_transacao_id_cliente_realizada_em ON transacao (id_cliente, realizada_em DESC);


CREATE OR REPLACE FUNCTION efetuar_transacao(
clienteIdParam int,
tipoParam varchar(1),
valorParam int,
descricaoParam varchar(10)
)
RETURNS TABLE (saldo int, limite int) AS $$
DECLARE
cliente cliente%rowtype;
novoSaldo
int;
numeroLinhasAfetadas
int;
BEGIN
PERFORM
* FROM cliente where id = clienteIdParam FOR
UPDATE;
IF
tipoParam = 'd' THEN
novoSaldo := valorParam * -1;
ELSE
novoSaldo := valorParam;
END IF;

UPDATE cliente
SET saldos = saldos + novoSaldo
WHERE id = clienteIdParam
  AND (novoSaldo > 0 OR limites * -1 <= saldos + novoSaldo) RETURNING *
INTO cliente;

GET DIAGNOSTICS numeroLinhasAfetadas = ROW_COUNT;

IF
numeroLinhasAfetadas = 0 THEN
RAISE EXCEPTION '';
END IF;

INSERT INTO transacao (id_cliente, valor, tipo, descricao, realizada_em)
VALUES (clienteIdParam, valorParam, tipoParam, descricaoParam, current_timestamp);


RETURN QUERY SELECT cliente.saldos AS saldo, cliente.limites AS limite;
END;
$$
LANGUAGE plpgsql;