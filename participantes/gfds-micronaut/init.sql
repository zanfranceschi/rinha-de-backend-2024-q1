DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS clients;

CREATE UNLOGGED TABLE clients (
    id SERIAL PRIMARY KEY,
    limite INT NOT NULL,
    saldo BIGINT DEFAULT 0
);
/* client searching index */
CREATE INDEX client_id_index
    ON clients(id)
    INCLUDE (saldo);

CREATE UNLOGGED TABLE transactions (
     id SERIAL PRIMARY KEY,
     client_id INT NOT NULL,
     valor INT NOT NULL,
     tipo CHAR NOT NULL,
     descricao VARCHAR(10) NOT NULL,
     realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES clients(id)
);
CREATE INDEX tansaction_id_index ON transactions(id);

INSERT INTO clients VALUES (1, 1000*100), (2, 800*100), (3, 10000*100), (4, 100000*100),(5, 5000*100);

CREATE OR REPLACE FUNCTION new_balance(
    client_id INT,
    tipo CHAR,
    valor INT
)
RETURNS INT
LANGUAGE plpgsql
AS $$
    DECLARE current_balance INT;
    BEGIN
        SELECT saldo INTO current_balance FROM clients WHERE id = client_id;

        CASE tipo
            WHEN 'c' THEN
                RETURN current_balance + valor;
            WHEN 'd' THEN
                RETURN current_balance - valor;
            ELSE
                RAISE EXCEPTION 'Tipo de transação inválida';
        END CASE;

    END;
$$;

CREATE OR REPLACE FUNCTION get_transactions(
    cId INT
)
RETURNS TABLE (valor INT, tipo CHAR, descricao VARCHAR(10), realizada_em TIMESTAMP)
LANGUAGE plpgsql
AS $$
   BEGIN
       RETURN QUERY
           SELECT transactions.valor, transactions.tipo, transactions.descricao, transactions.realizada_em
           FROM transactions
           WHERE transactions.client_id = cId;
    END;
$$;

CREATE OR REPLACE PROCEDURE credit(
    client_id INT,
    valor INT,
    descricao VARCHAR(10),
    OUT res INT
)
LANGUAGE plpgsql
AS $$
    DECLARE new_balance INT;
    BEGIN

        INSERT INTO transactions (client_id, valor, tipo, descricao)
        VALUES (client_id, valor, 'c', descricao);

        PERFORM pg_advisory_lock(client_id);
        new_balance := new_balance(client_id, 'c', valor);
        UPDATE clients SET saldo = new_balance WHERE id = client_id;
        PERFORM pg_advisory_unlock(client_id);

        res := new_balance;
    END;
$$;

CREATE OR REPLACE PROCEDURE debit(
    client_id INT,
    valor INT,
    descricao VARCHAR(10),
    OUT res INT
)
    LANGUAGE plpgsql
AS $$
    DECLARE new_balance INT;
    BEGIN
        INSERT INTO transactions (client_id, valor, tipo, descricao)
        VALUES (client_id, valor, 'd', descricao);

        PERFORM pg_advisory_lock(client_id);
        new_balance := new_balance(client_id, 'd', valor);
        UPDATE clients SET saldo = new_balance WHERE id = client_id;
        PERFORM pg_advisory_unlock(client_id);

        res := new_balance;
    END;
$$;




