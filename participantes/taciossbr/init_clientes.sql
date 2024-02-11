CREATE TABLE clientes (
    id INT PRIMARY KEY,
    limite BIGINT NOT NULL,
    saldo BIGINT NOT NULL DEFAULT '0'
    -- TODO ver se o INTEGER e suficiente
);

CREATE TYPE tipo_transacao AS ENUM ('c', 'd');
CREATE TABLE transacoes(
    id SERIAL PRIMARY KEY, -- TODO ver se precisa disso
    valor BIGINT NOT NULL,
    tipo tipo_transacao NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
    cliente_id INT NOT NULL REFERENCES clientes(id)
);

INSERT INTO clientes VALUES
('1', '100000', '0'),
('2', '80000', '0'),
('3', '1000000', '0'),
('4', '10000000', '0'),
('5', '500000', '0');

CREATE OR REPLACE PROCEDURE insert_transacao(
  pvalor BIGINT,
  ptipo tipo_transacao,
  pdescricao VARCHAR(10),
  pcliente_id INTEGER,
  
  INOUT v_saldo BIGINT DEFAULT NULL,
  INOUT v_limite BIGINT DEFAULT NULL,
  INOUT v_status SMALLINT DEFAULT 0
  -- 0 => OK
  -- 404 => OK
  -- 422 => OK
)
LANGUAGE plpgsql
AS $$
DECLARE
    vcliente_id INTEGER := NULL;
BEGIN
    SELECT id FROM clientes
    INTO vcliente_id
    WHERE id = pcliente_id
    FOR UPDATE;

    if vcliente_id is NULL then
        v_status := 404;
        return;
    end if;

    if ptipo = 'c' then
          UPDATE clientes
          SET saldo = saldo + pvalor
          WHERE id = pcliente_id
          RETURNING saldo, limite INTO v_saldo, v_limite;
    elsif ptipo = 'd' then
          UPDATE clientes
          SET saldo = saldo - pvalor
          WHERE id = pcliente_id AND saldo - pvalor >= -limite
          RETURNING saldo, limite INTO v_saldo, v_limite;
          if v_saldo is null then
              v_status := 422;
              return;
          end if;
    end if;
    INSERT INTO transacoes
    (valor, tipo, descricao, cliente_id)
    VALUES
    (pvalor, ptipo, pdescricao, pcliente_id);
END;
$$;


CREATE OR REPLACE PROCEDURE extrato(
  cid INTEGER,
  INOUT cliente refcursor,
  INOUT transacoes refcursor
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN cliente FOR
    SELECT id, limite, saldo AS total FROM clientes
    WHERE id = cid;

    OPEN transacoes FOR
    SELECT valor, tipo, descricao, realizada_em FROM transacoes
    WHERE cliente_id = cid
    ORDER BY id DESC
    LIMIT 10;
END;
$$;

CREATE INDEX IF NOT EXISTS saldo_index ON clientes(saldo);
CREATE INDEX IF NOT EXISTS id_trc ON transacoes(id DESC);
CREATE INDEX IF NOT EXISTS cid_transacoes ON transacoes(cliente_id);

