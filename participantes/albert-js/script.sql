
CREATE UNLOGGED TABLE transacoes(
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    saldo INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX transacoes_idx ON transacoes(cliente_id);
SET enable_seqscan=off;

CREATE TYPE json_result AS (
  body json,
  status_code INT
);

CREATE OR REPLACE FUNCTION calcular_saldo(clientId INT, t_tipo CHAR, t_valor DECIMAL, t_descricao CHAR(10) , t_limite INT)
    RETURNS json as $$
    DECLARE
        saldo_atual INTEGER;
        limite_atual INTEGER;
        result json_result;
    BEGIN

        SELECT saldo INTO saldo_atual
        FROM transacoes
        WHERE cliente_id = clientId
        ORDER BY realizada_em DESC, id DESC
        LIMIT 1;
        
        IF NOT FOUND THEN
            saldo_atual := 0;
        END IF;

        limite_atual := t_limite;

        IF t_tipo = 'd' THEN
            IF (saldo_atual + (-1 * t_valor)) < (-1 * limite_atual) THEN
                result.body := '{"error": "Valor excede o limite de saldo disponível"}';
                result.status_code := 422;
                RETURN json_build_object('error','valor excede o limite de saldo disponível', 'code', 422);
            ELSE
                saldo_atual := saldo_atual + (-1 * t_valor);
            END IF;
        ELSIF t_tipo = 'c' THEN
            -- Verificar se o novo saldo ultrapassa o limite
            IF (saldo_atual + t_valor) > limite_atual THEN
                result.body :=  '{"error": "Valor excede o limite de crédito disponível"}';
                result.status_code := 422;
                RETURN json_build_object('error', 'Valor excede o limite de crédito disponível', 'code',422);
            ELSE
                saldo_atual := saldo_atual + t_valor;
            END IF;
        ELSE
            result.body := '{"error": "Tipo de transação inválido"}';
            result.status_code := 400;
            RETURN json_build_object('error','Tipo de transação inválido', 'code', 400);
        END IF;

        INSERT INTO transacoes (cliente_id, valor, tipo, descricao, realizada_em, saldo)
        VALUES (clientId, t_valor, t_tipo, t_descricao, now(), saldo_atual);

    RETURN json_build_object('saldo', saldo_atual,'limite', t_limite, 'code', 200);

EXCEPTION
    WHEN OTHERS THEN
        RAISE 'Error processing transaction: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;