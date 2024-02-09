CREATE OR REPLACE FUNCTION proc_transacao(p_cliente_id INT, p_valor INT, p_tipo VARCHAR, p_descricao VARCHAR)
RETURNS VOID as $$
DECLARE
    diff INT;
    v_saldo INT;
    v_limite INT;
BEGIN
	IF p_tipo = 'd' THEN
        diff := p_valor * -1;
    ELSE
        diff := p_valor;
    END IF;

	SELECT saldo, limite INTO v_saldo, v_limite FROM clientes WHERE id = p_cliente_id;

	IF v_saldo + diff < -1 * v_limite THEN
        RAISE 'LIMITE_INDISPONIVEL [%, %, %]', v_saldo, diff, v_limite;
    END IF;

	UPDATE clientes SET saldo = saldo + diff WHERE id = p_cliente_id;

	INSERT INTO transacoes (cliente_id, valor, tipo, descricao)
	VALUES (p_cliente_id, p_valor, p_tipo, p_descricao);
	
	RETURN;
EXCEPTION
    WHEN OTHERS THEN
        -- An error occurred, so rollback the transaction
        RAISE 'Error processing transaction: %', SQLERRM;
        ROLLBACK;
END;
$$ LANGUAGE plpgsql;