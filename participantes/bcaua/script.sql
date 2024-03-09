CREATE UNLOGGED TABLE clientes (
   id SERIAL PRIMARY KEY,
   nome VARCHAR(50) NOT NULL,
   limite INTEGER NOT NULL,
   saldo INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transacoes (
    id         SERIAL PRIMARY KEY,
    cliente_id INTEGER     NOT NULL,
    valor      INTEGER     NOT NULL,
    tipo   CHAR(1)     NOT NULL,
    descricao  VARCHAR(10) NOT NULL,
    realizado_em  TIMESTAMP   NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    CONSTRAINT fk_transacoes_cliente_id
        FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes (nome, limite)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);



CREATE OR REPLACE FUNCTION create_transacao_cliente(
  IN idcliente integer,
  IN valor integer,
  IN tipo char(1),
  IN descricao varchar(10)
) RETURNS TABLE (found integer, sal integer, lim integer) AS $$
DECLARE
  clienteencontrado clientes%rowtype;
  saldo_cliente INT;
  limite_cliente INT;
BEGIN
  SELECT * FROM clientes
  INTO clienteencontrado
  WHERE id = idcliente;

  IF not found THEN
    RETURN QUERY SELECT 0, 0, 0;
  END IF;

  INSERT INTO transacoes (valor, descricao, tipo, realizado_em, cliente_id)
    VALUES (valor, descricao, tipo, now() at time zone 'utc', idcliente);

  UPDATE clientes 
    SET saldo = saldo + valor
    WHERE id = idcliente AND (valor > 0 OR saldo + valor >= limite)
    RETURNING saldo, limite
    INTO saldo_cliente, limite_cliente;

    IF limite_cliente is NULL THEN
        RETURN QUERY SELECT 1, 0, 0;
    END IF;

    RETURN QUERY SELECT 2, saldo_cliente, limite_cliente;
END;$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_transactions(
  IN idcliente integer
) RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(json_build_object(
                  'valor', t.valor,
                  'tipo', t.tipo,
                  'descricao', t.descricao,
                  'realizado_em', t.realizado_em
                )) INTO result
    FROM (
        SELECT valor, tipo, descricao, realizado_em
        FROM transacoes
        WHERE cliente_id = idcliente
        ORDER BY realizado_em DESC
        LIMIT 10
    ) AS t;          
    RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION extrato(
  IN idcliente integer
) RETURNS TABLE (total INT, data_extrato TIMESTAMP, limitee INT, ultimas_transacoes JSON)  AS $$
DECLARE
  saldo_cliente INT;
  limite_cliente INT;
BEGIN
    SELECT saldo, limite FROM clientes
    INTO saldo_cliente, limite_cliente
    WHERE id = idcliente;

    RETURN QUERY SELECT saldo_cliente, NOW() at time zone 'utc' as data, limite_cliente, get_transactions(idcliente);
END;$$ LANGUAGE plpgsql;
