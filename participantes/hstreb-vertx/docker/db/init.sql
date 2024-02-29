CREATE UNLOGGED TABLE IF NOT EXISTS clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    valor INTEGER NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_transacoes ON transacoes (cliente_id, realizada_em desc);

CREATE OR REPLACE FUNCTION inserir_transcacao(cliente INTEGER, tipo CHAR(1), valor INTEGER, descricao VARCHAR(10))
RETURNS TABLE(saldo_novo INTEGER, limite INTEGER, erro BOOLEAN) AS $$
DECLARE
  saldo_atual INTEGER;
  limite INTEGER;
  saldo_novo INTEGER;
BEGIN
    SELECT c.saldo, c.limite INTO saldo_atual, limite FROM clientes c WHERE c.id = cliente FOR UPDATE;

    IF tipo = 'd' THEN
        saldo_novo := saldo_atual - valor;
    ELSE
        saldo_novo := saldo_atual + valor;
    END IF;

    IF saldo_novo + limite >= 0 THEN
        UPDATE clientes SET saldo = saldo_novo WHERE id = cliente;

        INSERT INTO transacoes (cliente_id, tipo, valor, descricao) VALUES (cliente, tipo, valor, descricao);

        RETURN QUERY SELECT saldo_novo, limite, false;
    ELSE
        RETURN QUERY SELECT 0, 0, true;
    END IF;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
  INSERT INTO clientes (nome, limite)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$