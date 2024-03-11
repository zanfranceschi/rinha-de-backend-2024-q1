CREATE UNLOGGED TABLE IF NOT EXISTS cliente (
	id bigint NOT NULL,
	limite bigint DEFAULT 0 NOT NULL,
	saldo bigint DEFAULT 0 NOT NULL,
	CONSTRAINT cliente_pk PRIMARY KEY (id)
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacao (
	id bigserial NOT NULL,
	id_cliente bigint NOT NULL,
	descricao varchar(10) NULL,
	tipo char(1) NOT NULL,
	valor bigint NOT NULL,
	realizada_em timestamp DEFAULT current_timestamp NULL,
	CONSTRAINT transacao_pk PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS transacao_id_cliente_idx ON transacao (id_cliente);

CREATE OR REPLACE FUNCTION registrar_transacao(
    p_id_cliente bigint,
    p_tipo char(1),
    p_descricao varchar(10),
    p_valor bigint
)
RETURNS TABLE (
    out_limite_cliente bigint,
    out_novo_saldo_cliente bigint,
    out_status varchar(2)
) AS
$$
declare
	v_id_cliente bigint;
BEGIN
	-- Atualiza o saldo do cliente e obtem o novo saldo
    UPDATE cliente
    SET saldo = saldo + (case when p_tipo = 'd' then
                            -p_valor
                         else
                            p_valor
                         end)
    WHERE id = p_id_cliente
    RETURNING id, limite, saldo INTO v_id_cliente, out_limite_cliente, out_novo_saldo_cliente;

   	if v_id_cliente = null then
   		out_status = 'CI'; --cliente inexistete
   	else
	    -- Verifica se o novo saldo ultrapassa o limite
	    IF p_tipo = 'd' and out_novo_saldo_cliente < 0 and ((-out_novo_saldo_cliente) > out_limite_cliente) then
	    	out_status = 'SI'; -- saldo insuficiente
	    ELSE
		    INSERT INTO transacao (id_cliente, descricao, tipo, valor)
		    VALUES (p_id_cliente, p_descricao, p_tipo, p_valor);

		   	out_status = 'OK';
	    END IF;
   	end if;
    return next;
END;
$$
LANGUAGE plpgsql;

DO $$
BEGIN
    IF NOT EXISTS (SELECT * from cliente) THEN
        INSERT INTO cliente (id, limite, saldo)
        VALUES
            (1, 100000, 0),
            (2, 80000, 0),
            (3, 1000000, 0),
            (4, 10000000, 0),
            (5, 500000, 0);
    end if;
end; $$
