DROP FUNCTION IF EXISTS obter_extrato;

CREATE OR REPLACE FUNCTION obter_extrato(
	IN clienteId INT
)
RETURNS TABLE (
	r_result_code VARCHAR(20),
	r_cliente_limite INT,
	r_cliente_saldo INT,
	r_cliente_saldo_atualizado_em TIMESTAMPTZ,
	r_tran_valor INT,
	r_tran_tipo CHAR(1),
	r_tran_descricao VARCHAR(10),
	r_tran_realizada_em TIMESTAMPTZ,
	r_tran_count INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	-- raise notice 'Id do Cliente %.', clienteId;

	IF NOT EXISTS(SELECT FROM clientes WHERE cliente_id = clienteId) THEN
		RETURN QUERY (SELECT
			'[NOT_FOUND]'::VARCHAR,
			NULL::INT,
			NULL::INT,
			NULL::TIMESTAMPTZ,
			NULL::INT,
			NULL::CHAR,
			NULL::VARCHAR,
			NULL::TIMESTAMPTZ,
			NULL::INT
		);
		RETURN;
		-- RAISE EXCEPTION '[NOT_FOUND]::Cliente não encontrado.';
	END IF;

	RETURN QUERY (
		WITH
			cte_saldo_cliente AS (
				SELECT
					cliente_id,
					limite,
					saldo,
					saldo_atualizado_em
				FROM clientes
				WHERE cliente_id = clienteId
			),
			cte_extrato_cliente AS (
				SELECT
					transacao_id,
					cliente_id,
					valor,
					tipo,
					descricao,
					realizada_em
				FROM transacoes
				WHERE cliente_id = clienteId
				ORDER BY realizada_Em DESC
				FETCH FIRST 10 ROWS ONLY
			)
			SELECT
				'[OK]'::VARCHAR,
				saldo.limite,
				saldo.saldo,
				saldo.saldo_atualizado_em,
				extrato.valor,
				extrato.tipo,
				extrato.descricao,
				extrato.realizada_em,
				(count(extrato.transacao_id) OVER())::INT
			FROM cte_saldo_cliente as saldo
			LEFT JOIN cte_extrato_cliente as extrato
				ON extrato.cliente_id = saldo.cliente_id
	);
END;
$$;

--################

DROP FUNCTION IF EXISTS criar_transacao;

CREATE OR REPLACE FUNCTION criar_transacao(
	IN clienteId INT,
	IN valor INT,
	IN tipo CHAR(1),
	IN descricao VARCHAR(10),
	IN realizadaEm TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
)
RETURNS TABLE (
	r_result_code VARCHAR(20),
	r_cliente_limite INT,
	r_cliente_saldo INT
)
LANGUAGE plpgsql
AS $$
DECLARE
	v_saldo_atual_cliente RECORD;
	v_valor_crebito INT;
BEGIN
	-- raise notice 'Id do Cliente %.', clienteId;

	SELECT limite, saldo
	FROM clientes
	WHERE cliente_id = clienteId
	INTO v_saldo_atual_cliente;

	-- raise notice 'Saldo do Cliente %.', v_saldo_atual_cliente;

	IF v_saldo_atual_cliente IS NULL THEN
		RETURN QUERY (SELECT
			'[NOT_FOUND]'::VARCHAR,
			NULL::INT,
			NULL::INT
		);
		RETURN;
		-- RAISE EXCEPTION '[NOT_FOUND]::Cliente não encontrado.';
	END IF;

	-- raise notice 'Novo saldo do Cliente %.', novo_valor_saldo;

	v_valor_crebito = CASE WHEN tipo = 'c' THEN valor ELSE -valor END;

	UPDATE clientes SET
		saldo = saldo + v_valor_crebito,
		saldo_atualizado_em = CURRENT_TIMESTAMP
	WHERE cliente_id = clienteId
	RETURNING limite, saldo
	INTO v_saldo_atual_cliente;

	-- raise notice 'Saldo atualizado do Cliente %.', v_saldo_atual_cliente;

	IF tipo = 'd' AND v_saldo_atual_cliente.saldo < -v_saldo_atual_cliente.limite THEN
		RETURN QUERY (SELECT
			'[LIMIT_EXCEEDED]'::VARCHAR,
			NULL::INT,
			NULL::INT
		);
		RETURN;
		-- RAISE EXCEPTION '[LIMIT_EXCEEDED]::O novo saldo do cliente excede o limite permitido.';
	END IF;

	INSERT INTO transacoes (cliente_id, valor, tipo, descricao, realizada_em, saldo)
	VALUES (
	  clienteId, valor, tipo, descricao, realizadaEm, v_saldo_atual_cliente.saldo
	);

	RETURN QUERY SELECT
		'[OK]'::VARCHAR,
		v_saldo_atual_cliente.limite,
		v_saldo_atual_cliente.saldo;
END;
$$;
