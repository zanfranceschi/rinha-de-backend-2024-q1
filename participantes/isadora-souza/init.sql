CREATE TABLE IF NOT EXISTS clientes (
    id SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(50) NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS transacoes (
    id SERIAL PRIMARY KEY NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    valor INTEGER NOT NULL,
    cliente_id INTEGER NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_cliente_id ON transacoes (cliente_id);

INSERT INTO clientes (nome, limite, saldo)
VALUES
    ('Isadora', 100000, 0),
    ('Maicon', 80000, 0),
    ('Matias', 1000000, 0),
    ('Bob', 10000000, 0),
    ('Tom', 500000, 0);

CREATE OR REPLACE FUNCTION atualizar_saldo()
RETURNS TRIGGER AS $$
DECLARE
    v_saldo INTEGER;
    v_limite INTEGER;
BEGIN
    SELECT saldo, limite INTO v_saldo, v_limite
    FROM clientes WHERE id = NEW.cliente_id
    FOR UPDATE;

    IF NEW.tipo = 'd' AND (v_saldo - NEW.valor) < -v_limite THEN
        RAISE EXCEPTION 'Débito excede o limite do cliente';
    END IF;

    IF NEW.tipo = 'd' THEN
        UPDATE clientes SET saldo = saldo - NEW.valor WHERE id = NEW.cliente_id;
    ELSE
        UPDATE clientes SET saldo = saldo + NEW.valor WHERE id = NEW.cliente_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualizar_saldo_trigger
AFTER INSERT ON transacoes
FOR EACH ROW
EXECUTE FUNCTION atualizar_saldo();