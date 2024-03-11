CREATE UNLOGGED TABLE IF NOT EXISTS customers (
    "id"                SERIAL,
    "limit"             INT NOT NULL,
    "balance"           INT DEFAULT 0,
    PRIMARY KEY (id)
);

CREATE UNLOGGED TABLE IF NOT EXISTS transactions (
    "id"           SERIAL,
    "value"        INT NOT NULL,
    "type"         VARCHAR(1) NOT NULL,
    "description"  VARCHAR(10) NOT NULL,
    "created_at"   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "customer_id"  INT NOT NULL,
    CONSTRAINT "customers_fk" FOREIGN KEY ("customer_id") REFERENCES customers("id")
);

CREATE OR REPLACE FUNCTION update_balance(
  customer_id INT,
  operation_type CHAR(1),
  transaction_value NUMERIC,
  OUT message TEXT,
  OUT is_error BOOLEAN,
  OUT updated_balance NUMERIC,
  OUT customer_limit NUMERIC) AS $$
DECLARE
    customer_record RECORD;
    customer_balance NUMERIC;
BEGIN
    SELECT * INTO customer_record FROM customers WHERE id = customer_id FOR UPDATE;

    IF NOT FOUND THEN
        message := 'Cliente não encontrado';
        is_error := true;
        updated_balance := 0;
        customer_limit := 0;
        RETURN;
    END IF;

    IF operation_type = 'c' THEN
        customer_balance := customer_record.balance + transaction_value;
    END IF;
    IF operation_type = 'd' THEN
        customer_balance := customer_record.balance - transaction_value;

        IF customer_record.limit + customer_balance < 0 THEN
            message := 'Limite permitido foi atingido';
            is_error := true;
            updated_balance := 0;
            customer_limit := 0;
            RETURN;
        END IF;
    END IF;

    UPDATE customers SET balance = customer_balance
    WHERE id = customer_id;

    IF FOUND THEN
        message := 'Saldo do cliente atualizado com sucesso';
        is_error := false;
        updated_balance := customer_balance;
        customer_limit := customer_record.limit;
    ELSE
        message := 'Falha ao atualizar cliente';
        is_error := true;
        updated_balance := 0;
        customer_limit := 0;
    END IF;
END;
$$ LANGUAGE plpgsql;

INSERT INTO customers ("limit")
VALUES
    (1000 * 100),
    (800 * 100),
    (10000 * 100),
    (100000 * 100),
    (5000 * 100);

