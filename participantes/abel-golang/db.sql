CREATE TABLE IF NOT EXISTS clientes (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (
    id SERIAL PRIMARY KEY,
    idCliente INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    dataCriacao TIMESTAMP NOT NULL
);

INSERT INTO clientes (limite)
VALUES
  (1000 * 100),
  (800 * 100),
  (10000 * 100),
  (100000 * 100),
  (5000 * 100);

ALTER TABLE transacoes
SET (autovacuum_enabled = false);

CREATE INDEX idx_transacoes ON transacoes (idCliente ASC);

CREATE OR REPLACE FUNCTION debitar(
    idClienteTx INTEGER,
    valorTx INT,
    descricaoTx VARCHAR(10))
RETURNS TABLE (
    novoSaldo INT,
    sucesso BOOL,
    limite INT)
LANGUAGE plpgsql
AS $$
DECLARE
    saldoAtual INT;
    limiteAtual INT;
BEGIN
    PERFORM pg_advisory_xact_lock(idClienteTx);

    SELECT 
        clientes.limite,
        clientes.saldo
    INTO
        limiteAtual,
        saldoAtual
    FROM clientes
    WHERE id = idClienteTx;

    IF saldoAtual - valorTx >= limiteAtual * -1 THEN
        INSERT INTO transacoes VALUES(DEFAULT, idClienteTx, valorTx, 'd', descricaoTx, NOW());
        
        RETURN QUERY
        UPDATE clientes 
        SET saldo = saldo - valorTx 
        WHERE id = idClienteTx
        RETURNING saldo, TRUE, limiteAtual;
    ELSE
        RETURN QUERY SELECT saldoAtual, FALSE, limiteAtual;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION creditar(
    idClienteTx INTEGER,
    valorTx INT,
    descricaoTx VARCHAR(10))
RETURNS TABLE (
    novoSaldo INT,
    sucesso BOOL,
    limiteAtual INT)
LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM pg_advisory_xact_lock(idClienteTx);

    INSERT INTO transacoes VALUES(DEFAULT, idClienteTx, valorTx, 'c', descricaoTx, NOW());

    RETURN QUERY
        UPDATE clientes
        SET saldo = saldo + valorTx
        WHERE id = idClienteTx
        RETURNING saldo, TRUE, clientes.limite;
END;
$$;
