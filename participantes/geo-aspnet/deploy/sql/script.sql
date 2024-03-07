CREATE DATABASE RinhaBackend;

\c RinhaBackend;

CREATE UNLOGGED TABLE Clientes (
    Id serial,
    Limite int NOT NULL,
    Saldo int NOT NULL
);
 CREATE INDEX clientes_id_idx ON Clientes (Id);

INSERT INTO Clientes (Limite, Saldo)
VALUES
(100000, 0),
(80000, 0),
(1000000, 0),
(10000000, 0),
(500000, 0);

CREATE UNLOGGED TABLE Transacoes (
    Id SERIAL PRIMARY KEY,
    Cliente_Id INTEGER NOT NULL,
    Valor INTEGER NOT NULL,
    Tipo CHAR(1) NOT NULL,
    Descricao VARCHAR(10) NOT NULL,
    Realizada_Em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_transacoes_cliente_id ON Transacoes (Cliente_Id);


CREATE OR REPLACE FUNCTION InserirTransacao(cliente_id INTEGER, valor INTEGER, tipo CHAR, descricao TEXT)
RETURNS TABLE (limite INTEGER, saldo INTEGER) AS $$
DECLARE
    current_limite INTEGER;
    current_saldo INTEGER;
BEGIN    
    SELECT clientes.limite, clientes.saldo INTO current_limite, current_saldo FROM clientes WHERE id = cliente_id FOR UPDATE;

    IF tipo = 'c' THEN
        current_saldo := current_saldo + valor;
    ELSE
        current_saldo := current_saldo - valor;
    END IF;

    IF current_saldo < 0 AND ABS(current_saldo) > current_limite THEN
        RETURN;
    ELSE    
        INSERT INTO Transacoes (Cliente_Id, Valor, Tipo, Descricao, Realizada_Em)
        VALUES (cliente_id, valor, tipo, descricao, CURRENT_TIMESTAMP);

        UPDATE Clientes SET Saldo = current_saldo WHERE Id = cliente_id;

        RETURN QUERY SELECT current_limite, current_saldo;
    END IF;
END;
$$ LANGUAGE plpgsql;
