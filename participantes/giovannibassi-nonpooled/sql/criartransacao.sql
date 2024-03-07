CREATE OR REPLACE FUNCTION criartransacao(
  IN idcliente integer,
  IN valor integer,
  IN descricao varchar(10)
) RETURNS RECORD AS $$
DECLARE
  clienteencontrado cliente%rowtype;
  ret RECORD;
BEGIN
  SELECT * FROM cliente
  INTO clienteencontrado
  WHERE id = idcliente;

  IF not found THEN
    SELECT -1 INTO ret;
    RETURN ret;
  END IF;

  UPDATE cliente
    SET saldo = saldo + valor
    WHERE id = idcliente AND (valor > 0 OR saldo + valor >= limite)
    RETURNING saldo, limite
    INTO ret;
  IF ret.limite is NULL THEN
    SELECT -2 INTO ret;
    RETURN ret;
  END IF;
  INSERT INTO transacao (valor, descricao, idcliente)
    VALUES (valor, descricao, idcliente);
  RETURN ret;
END;$$ LANGUAGE plpgsql;
