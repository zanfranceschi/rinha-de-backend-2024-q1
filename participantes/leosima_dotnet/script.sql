CREATE UNLOGGED TABLE cliente (
    "id" INT,
	"nome" VARCHAR(100) NOT NULL,
    "limite" INT NOT NULL,
    "saldo" INT NOT NULL,
    PRIMARY KEY(id)
);

CREATE UNLOGGED TABLE transacao (
    "id" INT GENERATED ALWAYS AS IDENTITY,
    "idCliente" INT NOT NULL,
    "valor" INT NOT NULL,
    "tipo" CHAR(1) NOT NULL,
    "descricao" text NOT NULL,
    data TIMESTAMP NOT NULL,
    PRIMARY KEY("id"),
    CONSTRAINT fk_cliente
        FOREIGN KEY ("idCliente")
            REFERENCES cliente(id)
            ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION realizar_transacao (
    p_idCliente INT,
    p_valor INT,
    p_tipo CHAR(1),
    p_descricao VARCHAR(10)
) RETURNS TABLE (limite_cliente INT, novo_saldo INT) AS $$
DECLARE
    v_saldo INT;
    v_limite INT;
BEGIN
    SELECT saldo, limite INTO v_saldo, v_limite 
    FROM cliente 
    WHERE id = p_idCliente FOR UPDATE;

    IF p_tipo = 'd' THEN
   		IF v_saldo - p_valor < (v_limite * -1) then
   			raise exception 'RN02:Limite insuficiente pra transacao';
   		END IF;
    END IF;
    
    IF p_tipo = 'd' THEN
        UPDATE cliente SET saldo = saldo - p_valor WHERE id = p_idCliente;
    ELSIF p_tipo = 'c' THEN
        UPDATE cliente SET saldo = saldo + p_valor WHERE id = p_idCliente;
    END IF;

    INSERT INTO transacao (valor, tipo, descricao, "idCliente", data)
    VALUES
        (p_valor, p_tipo, p_descricao, p_idCliente, CURRENT_TIMESTAMP);

    RETURN QUERY SELECT saldo, limite FROM cliente WHERE id = p_idCliente;
END;
$$ LANGUAGE plpgsql;

INSERT INTO cliente (id, nome, limite, saldo) VALUES
(1, 'Fulano', 100000, 0),
(2, 'Ciclano', 80000, 0),
(3, 'Beltrano', 1000000, 0),
(4, 'Betina', 10000000, 0),
(5, 'Firmina', 500000, 0);
