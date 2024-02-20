CREATE TABLE cliente (
    id INT PRIMARY KEY,
    saldo INT NOT NULL,
    limite INT NOT NULL
);

CREATE TABLE transacao (
    id SERIAL PRIMARY KEY,
    valor INT NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizado_em TIMESTAMP NOT NULL DEFAULT NOW(),
    cliente_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE INDEX idx_cliente ON cliente(id) INCLUDE (saldo, limite);
CREATE INDEX idx_transacao_cliente ON transacao(cliente_id);

INSERT INTO cliente (Id, limite, saldo) VALUES
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);

CREATE OR REPLACE FUNCTION criartransacao(
    IN id_cliente INT,
    IN valor INT,
    IN tipo CHAR(1),
    IN descricao varchar(10)
) RETURNS RECORD AS $$
DECLARE
    ret RECORD;
BEGIN
    PERFORM id FROM cliente
    WHERE id = id_cliente;

    IF not found THEN
    select 1 into ret;
    RETURN ret;
    END IF;

    INSERT INTO transacao (valor, tipo, descricao, cliente_id)
    VALUES (ABS(valor), tipo, descricao, id_cliente);
    UPDATE cliente
    SET saldo = saldo + valor
    WHERE id = id_cliente AND (valor > 0 OR saldo + valor >= -limite)
    RETURNING saldo, limite
    INTO ret;

    IF ret.limite is NULL THEN
        select 2 into ret;
    END IF;
    
    RETURN ret;
END;
$$ LANGUAGE plpgsql;
