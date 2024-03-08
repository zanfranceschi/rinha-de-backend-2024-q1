CREATE UNLOGGED TABLE "clientes" (
    "id" SERIAL NOT NULL,
    "saldo" INTEGER NOT NULL,
    "limite" INTEGER NOT NULL,

    CONSTRAINT "clientes_pkey" PRIMARY KEY ("id")
);

CREATE UNLOGGED TABLE "transacoes" (
    "id" SERIAL NOT NULL,
    "valor" INTEGER NOT NULL,
    "id_cliente" INTEGER NOT NULL,
    "tipo" CHAR(1) NOT NULL,
    "descricao" VARCHAR(10) NOT NULL,
    "realizada_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "transacoes_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "transacoes_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "clientes"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE INDEX idx_saldo_limite ON clientes (saldo, limite);
CREATE INDEX idx_id_cliente ON transacoes (id_cliente);

CREATE OR REPLACE FUNCTION debitar(
  IN id_cliente integer,
  IN valor integer,
  IN descricao varchar(10)
) RETURNS json AS $$

DECLARE
  ret RECORD;
BEGIN
  INSERT INTO transacoes (valor, descricao, realizada_em, id_cliente, tipo)
    VALUES (valor, descricao, now() at time zone 'utc', id_cliente, 'd');
  UPDATE clientes
    SET saldo = saldo - valor
    WHERE id = id_cliente AND (saldo - valor >= limite * -1)
    RETURNING saldo, limite
    INTO ret;
  IF ret.limite is NULL THEN
    ret.saldo := -6; -- se
    ret.limite := -9; -- xo
  END IF;
  RETURN row_to_json(ret);
END;$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION creditar(
  IN id_cliente integer,
  IN valor integer,
  IN descricao varchar(10)
) RETURNS json AS $$
DECLARE
  ret RECORD;
BEGIN
  INSERT INTO transacoes (valor, descricao, realizada_em, id_cliente, tipo)
    VALUES (valor, descricao, now() at time zone 'utc', id_cliente, 'c');
  UPDATE clientes
    SET saldo = saldo + valor
    WHERE id = id_cliente
    RETURNING saldo, limite
    INTO ret;
    
  RETURN row_to_json(ret);
END;$$ LANGUAGE plpgsql;

DO $$
BEGIN
    INSERT INTO clientes (saldo, limite)
    VALUES
        (0, 1000 * 100),
        (0, 800 * 100),
        (0, 10000 * 100),
        (0, 100000 * 100),
        (0, 5000 * 100);
END;
$$;