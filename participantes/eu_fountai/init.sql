CREATE TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL
);

CREATE TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE saldos (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	CONSTRAINT fk_clientes_saldos_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- INDEX
CREATE INDEX idx_clientes_id ON clientes (id);
CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id);
CREATE INDEX idx_saldos_cliente_id ON saldos (cliente_id);

---	STORE PROCEDURE
CREATE OR REPLACE FUNCTION obter_saldo_limite(cliente_id_param INTEGER)
RETURNS JSON AS $$
DECLARE
    resultado JSON;
BEGIN
    SELECT json_build_object('saldo', s.valor, 'limite', c.limite)
    INTO resultado
    FROM saldos s
    JOIN clientes c ON s.cliente_id = c.id
    WHERE s.cliente_id = cliente_id_param;

    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obter_extrato(cliente_id_param INTEGER)
RETURNS JSON AS $$
DECLARE
    extrato JSON;
BEGIN
    SELECT json_build_object(
        'saldo', json_build_object(
            'total', (SELECT valor FROM saldos WHERE cliente_id = cliente_id_param),
            'data_extrato', NOW(),
            'limite', (SELECT limite FROM clientes WHERE id = cliente_id_param)
        ),
        'ultimas_transacoes', COALESCE((
            SELECT json_agg(json_build_object(
                'valor', t.valor,
                'tipo', t.tipo,
                'descricao', t.descricao,
                'realizada_em', t.realizada_em
            ) ORDER BY t.realizada_em DESC)
            FROM transacoes t
            WHERE t.cliente_id = cliente_id_param
            LIMIT 10
        ), '[]'::JSON)
    )
    INTO extrato;

    RETURN extrato;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION transacao(cliente_id_param INTEGER, valor_param INTEGER, tipo_param CHAR(1), descricao_param VARCHAR(10))
RETURNS JSON AS $$
DECLARE
    saldo_atual INTEGER;
    limite_atual INTEGER;
    novo_saldo INTEGER;
    resultado JSON;
BEGIN
    SELECT valor INTO saldo_atual FROM saldos WHERE cliente_id = cliente_id_param;
    SELECT limite INTO limite_atual FROM clientes WHERE id = cliente_id_param;

    IF (valor_param > (saldo_atual + limite_atual)) THEN
        resultado := json_build_object('limite', limite_atual, 'saldo', saldo_atual);
    ELSE
        INSERT INTO transacoes (cliente_id, valor, tipo, descricao)
        VALUES (cliente_id_param, valor_param, tipo_param, descricao_param);

        novo_saldo := saldo_atual - valor_param;

        UPDATE saldos SET valor = novo_saldo WHERE cliente_id = cliente_id_param;

        SELECT json_build_object('limite', limite_atual, 'saldo', novo_saldo) INTO resultado;
    END IF;

    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION reset_db()
RETURNS VOID AS $$
BEGIN
    DELETE FROM transacoes;
    UPDATE saldos SET valor = 0;
END;
$$ LANGUAGE plpgsql;

--- SEED
DO $$
BEGIN
	INSERT INTO clientes (nome, limite)
	VALUES
		('user 1', 1000 * 100),
		('user 2', 800 * 100),
		('user 3', 10000 * 100),
		('user 4', 100000 * 100),
		('user 5', 5000 * 100);
	
	INSERT INTO saldos (cliente_id, valor)
		SELECT id, 0 FROM clientes;
END;
$$;