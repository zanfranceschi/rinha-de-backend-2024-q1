CREATE UNLOGGED TABLE conta (
                        id_cliente INT PRIMARY KEY NOT NULL,
                        saldo_inicial_em_centavos BIGINT NOT NULL,
                        limite_em_centavos BIGINT NOT NULL,
                        saldo_atual_em_centavos BIGINT NOT NULL
);

CREATE UNLOGGED TABLE transacao (
                            id BIGSERIAL PRIMARY KEY NOT NULL,
                            valor_em_centavos BIGINT NOT NULL,
                            tipo CHAR(1) NOT NULL,
                            descricao VARCHAR(10),
                            realizada_em TIMESTAMP WITH TIME ZONE NOT NULL,
                            id_cliente INT NOT NULL,
                            FOREIGN KEY (id_cliente) REFERENCES conta(id_cliente)
);

-- CREATE INDEX idx_transacao_id_cliente ON transacao(id_cliente);

-----------------------------
-- Procedimento de atualização do saldo e inclusão da transação.

CREATE OR REPLACE PROCEDURE atualizar_saldo_e_inserir_transacao(
    _id_cliente BIGINT,
    _valor_em_centavos BIGINT,
    _tipo CHAR(1),
    _descricao VARCHAR(10),
    INOUT _retorno VARCHAR(100))
LANGUAGE plpgsql AS $$
DECLARE
    v_saldo_atual INT;
    v_limite INT;
BEGIN
    IF _tipo = 'd' THEN
        UPDATE conta
        SET saldo_atual_em_centavos = saldo_atual_em_centavos - _valor_em_centavos
        WHERE id_cliente = _id_cliente
          AND saldo_atual_em_centavos - _valor_em_centavos >= -limite_em_centavos
            RETURNING saldo_atual_em_centavos, limite_em_centavos INTO v_saldo_atual, v_limite;
    ELSE
        UPDATE conta
        SET saldo_atual_em_centavos = saldo_atual_em_centavos + _valor_em_centavos
        WHERE id_cliente = _id_cliente
            RETURNING saldo_atual_em_centavos, limite_em_centavos INTO v_saldo_atual, v_limite;
    END IF;

    -- Só não retornará se não tiver saldo suficiente. A existência do cliente é verificada na aplicação.
    IF NOT FOUND THEN
      _retorno = 'SI'; -- Saldo insuficiente.
      RETURN;
    ELSE
      -- Insere a nova transação.
      INSERT INTO transacao (id_cliente, realizada_em, valor_em_centavos, tipo, descricao) VALUES (_id_cliente, NOW(), _valor_em_centavos, _tipo, _descricao);
      COMMIT;
      _retorno = CONCAT(v_saldo_atual::varchar, ':', v_limite::varchar);
    END IF;
END;
$$;

-----------------------------
-- Inserção de dados de teste.

INSERT INTO conta (id_cliente, saldo_inicial_em_centavos, limite_em_centavos, saldo_atual_em_centavos)
VALUES
    (1, 0, 100000, 0),
    (2, 0, 80000, 0),
    (3, 0, 1000000, 0),
    (4, 0, 10000000, 0),
    (5, 0, 500000, 0);