-- CreateEnum
CREATE TYPE "transaction_type" AS ENUM ('credit', 'debit');

-- CreateTable
CREATE TABLE "clients" (
    "id" SERIAL NOT NULL,
    "balance" DECIMAL(12,0) NOT NULL,
    "limit" DECIMAL(12,0) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "clients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transactions" (
    "id" SERIAL NOT NULL,
    "client_id" INTEGER NOT NULL,
    "amount" DECIMAL(12,0) NOT NULL,
    "type" "transaction_type" NOT NULL,
    "description" VARCHAR(10) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "transactions_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "clients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


CREATE OR REPLACE FUNCTION process_debit(
    p_client_id INT,
    p_valor NUMERIC,
    p_description TEXT
) RETURNS JSON AS $$
DECLARE
    v_client_balance NUMERIC;
    v_client_limit NUMERIC;
BEGIN
    -- Check if client exists
    IF NOT EXISTS (SELECT 1 FROM clients WHERE id = p_client_id) THEN
        RAISE EXCEPTION 'Client does not exist';
    END IF;

    -- Start a transaction block
    BEGIN
        -- Fetch client's balance and limit
        SELECT balance, "limit"
        INTO v_client_balance, v_client_limit
        FROM clients
        WHERE id = p_client_id
        FOR UPDATE;

        -- Check if debit exceeds limit
        IF (v_client_balance - p_valor) < -v_client_limit THEN
            RAISE EXCEPTION 'Limit exceeded';
        END IF;


        -- Update client's balance
        UPDATE clients
        SET balance = balance - p_valor
        WHERE id = p_client_id;

        -- Create debit transaction
        INSERT INTO transactions (client_id, amount, type, description)
        VALUES (p_client_id, p_valor, 'debit', p_description);

        -- Commit the transaction
    EXCEPTION
        WHEN OTHERS THEN
            -- Re-raise the error
            RAISE;
    END;
    -- Return updated client data
    RETURN (SELECT json_build_object(
        'id', p_client_id,
        'balance', balance,
        'limit', "limit"
    ) FROM clients WHERE id = p_client_id);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION process_credit(
    p_client_id INT,
    p_valor NUMERIC,
    p_description TEXT
) RETURNS JSON AS $$
DECLARE
    v_client_balance NUMERIC;
    v_client_limit NUMERIC;
BEGIN
    -- Check if client exists
    IF NOT EXISTS (SELECT 1 FROM clients WHERE id = p_client_id) THEN
        RAISE EXCEPTION 'Client does not exist';
    END IF;

    -- Start a transaction block
    BEGIN
        -- Update client's balance
        UPDATE clients
        SET balance = balance + p_valor
        WHERE id = p_client_id;

        -- Create debit transaction
        INSERT INTO transactions (client_id, amount, type, description)
        VALUES (p_client_id, p_valor, 'credit', p_description);

        -- Commit the transaction
    EXCEPTION
        WHEN OTHERS THEN
            -- Re-raise the error
            RAISE;
    END;
    -- Return updated client data
    RETURN (SELECT json_build_object(
        'id', p_client_id,
        'balance', balance,
        'limit', "limit"
    ) FROM clients WHERE id = p_client_id);
END;
$$ LANGUAGE plpgsql;


INSERT INTO clients ("limit", balance)
VALUES
    (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);
