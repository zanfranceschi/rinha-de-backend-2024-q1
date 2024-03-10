CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    balance INT NOT NULL DEFAULT 0,
    lmt INT NOT NULL
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    client_id INT,
    value INT NOT NULL,
    type CHAR(1) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(10) NOT NULL,
    CONSTRAINT fk_client_id FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE
);

CREATE INDEX idx_client_id ON clients (id);

CREATE INDEX idx_transactions_by_client_and_created_at ON transactions (client_id, created_at DESC);

CREATE OR REPLACE FUNCTION update_client_balance(
    client_id_arg INT,
    transaction_value_arg INT,
    transaction_type_arg CHAR(1),
    transaction_description_arg VARCHAR(10),
    OUT text_message TEXT,
    OUT is_error BOOLEAN,
    OUT updated_balance NUMERIC,
    OUT client_limit NUMERIC
) AS $$
DECLARE
    client_record RECORD;
    client_new_balance INT;
    client_existed_limit INT;
BEGIN
    SELECT * INTO client_record FROM clients WHERE id = client_id_arg FOR UPDATE;
    IF NOT FOUND THEN
        updated_balance := 0;
        client_limit := 0;
        is_error := true;
        text_message := 'CLIENT_NOT_FOUND';
        RETURN;
    END IF;

    client_existed_limit := client_record.lmt;

    IF transaction_type_arg = 'c' THEN
        client_new_balance := client_record.balance + transaction_value_arg;
    ELSIF transaction_type_arg = 'd' THEN
        client_new_balance := client_record.balance - transaction_value_arg;
        IF client_new_balance < -client_existed_limit THEN
            updated_balance := 0;
            client_limit := 0;
            is_error := true;
            text_message := 'LIMIT_EXCEEDED';
            RETURN;
        END IF;
    END IF;

    UPDATE clients SET balance = client_new_balance WHERE id = client_id_arg;

    INSERT INTO transactions (client_id, value, type, description)
    VALUES (client_id_arg, transaction_value_arg, transaction_type_arg, transaction_description_arg);

    updated_balance := client_new_balance;
    client_limit := client_existed_limit;
    is_error := false;
    text_message := 'SUCCESS';
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
    INSERT INTO clients (name, lmt)
    VALUES
        ('o barato sai caro', 1000 * 100),
        ('zan corp ltda', 800 * 100),
        ('les cruders', 10000 * 100),
        ('padaria joia de cocaia', 100000 * 100),
        ('kid mais', 5000 * 100);
END; $$
