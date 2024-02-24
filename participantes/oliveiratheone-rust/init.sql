CREATE UNLOGGED TABLE
    "clientes" (
                   "id" SERIAL NOT NULL,
                   "saldo" INTEGER NOT NULL,
                   "limite" INTEGER NOT NULL,
                   CONSTRAINT "clientes_pkey" PRIMARY KEY ("id")
);

CREATE UNLOGGED TABLE
    "transacoes" (
                     "id" SERIAL NOT NULL,
                     "valor" INTEGER NOT NULL,
                     "id_cliente" INTEGER NOT NULL,
                     "tipo" char(1) NOT NULL,
                     "descricao" VARCHAR(10) NOT NULL,
                     "realizada_em" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                     CONSTRAINT "transacoes_pkey" PRIMARY KEY ("id")
);

CREATE OR REPLACE FUNCTION get_extrato(customer_id INT)
    RETURNS JSON AS
$$
DECLARE
customer_data JSON;
    statements_data JSON;
BEGIN
SELECT json_build_object('total', saldo, 'limite', limite, 'data_extrato', now())
INTO customer_data
FROM clientes
WHERE id = customer_id;

SELECT COALESCE(json_agg(json_build_object('valor', valor, 'tipo', tipo, 'descricao', descricao, 'realizada_em', realizada_em)), '[]'::JSON)
INTO statements_data
FROM (
         SELECT valor, tipo, descricao, realizada_em
         FROM transacoes
         WHERE id_cliente = customer_id
         ORDER BY realizada_em DESC
             LIMIT 10
     ) AS t;

RETURN json_build_object(
        'saldo', customer_data,
        'ultimas_transacoes', statements_data
       );
END;
$$
LANGUAGE plpgsql;

CREATE INDEX transacoes_ordering ON transacoes (realizada_em DESC, id_cliente);

INSERT INTO
    clientes (saldo, limite)
VALUES
    (0, 1000 * 100),
    (0, 800 * 100),
    (0, 10000 * 100),
    (0, 100000 * 100),
    (0, 5000 * 100);