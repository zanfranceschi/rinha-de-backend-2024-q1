DROP TYPE IF EXISTS criartransacao_result;
CREATE TYPE criartransacao_result AS (
  result integer,
  saldo integer,
  limite integer
);
CREATE OR REPLACE FUNCTION criartransacao(
  IN idcliente integer,
  IN valor integer,
  IN descricao varchar(10)
) RETURNS criartransacao_result AS $$
DECLARE
  clienteencontrado cliente%rowtype;
  search RECORD;
  ret criartransacao_result;
BEGIN
  SELECT * FROM cliente
  INTO clienteencontrado
  WHERE id = idcliente;

  IF not found THEN
    SELECT -1, 0, 0 into ret;
    RETURN ret;
  END IF;

  INSERT INTO transacao (valor, descricao, realizadaem, idcliente)
    VALUES (valor, descricao, now() at time zone 'utc', idcliente);
  UPDATE cliente
    SET saldo = saldo + valor
    WHERE id = idcliente AND (valor > 0 OR saldo + valor >= limite)
    RETURNING saldo, limite
    INTO search;
  IF search.limite is NULL THEN
    SELECT -2, 0, 0 INTO ret;
    RETURN ret;
  ELSE
    SELECT 0, search.saldo, search.limite INTO ret;
  END IF;
  RETURN RET;
END;$$ LANGUAGE plpgsql;
