USE rinha;

CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    limite INT NOT NULL,
    saldo INT DEFAULT 0 NOT NULL,
    CHECK (saldo >= -limite)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS transacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    valor INT NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10),
    realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE INDEX idx_cliente_id ON transacoes(cliente_id);

DELIMITER //
CREATE TRIGGER create_transaction_trigger
BEFORE INSERT
ON transacoes FOR EACH ROW
BEGIN
    DECLARE v_limite INT;
    DECLARE v_saldo INT;

    IF NEW.valor < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction amount cannot be negative!';
    END IF;

    SELECT limite, saldo INTO v_limite, v_saldo FROM clientes WHERE id = NEW.cliente_id;

    IF NEW.tipo = 'c' THEN
        UPDATE clientes SET saldo = saldo + NEW.valor WHERE id = NEW.cliente_id;
    ELSEIF NEW.tipo = 'd' THEN
        IF (v_saldo + v_limite - NEW.valor) < 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Debit exceeds customer limit and balance!';
        ELSE
            UPDATE clientes SET saldo = saldo - NEW.valor WHERE id = NEW.cliente_id;
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid transaction!';
    END IF;
END;
//
DELIMITER ;

INSERT INTO clientes (nome, limite)
VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
