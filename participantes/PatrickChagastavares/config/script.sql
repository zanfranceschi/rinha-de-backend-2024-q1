ALTER SYSTEM SET max_connections = 1000;
ALTER SYSTEM SET TIMEZONE TO 'UTC';

CREATE TABLE IF NOT EXISTS clients
(
  id              BIGSERIAL       PRIMARY KEY,
  name            VARCHAR(100)    NOT NULL,
  limite          int             NOT NULL
);

INSERT INTO clients (name, limite)
VALUES
  ('o barato sai caro', 1000 * 100),
  ('zan corp ltda', 800 * 100),
  ('les cruders', 10000 * 100),
  ('padaria joia de cocaia', 100000 * 100),
  ('kid mais', 5000 * 100);

CREATE TYPE transactionType AS ENUM ('c', 'd');

CREATE TABLE IF NOT EXISTS transactions
(
  id            UUID              NOT NULL,
  type          transactionType   NOT NULL,
  value         int               NOT NULL,
  description   varchar(10)       NOT NULL,
  client_id     int               NOT NULL,
  last_balance  int               NOT NULL,
  created_at    TIMESTAMPTZ       NOT NULL    DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT transactions_pkey PRIMARY KEY (id),
  CONSTRAINT transactions_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id)
);
CREATE INDEX idx_last_transaction_per_client ON transactions (client_id, created_at DESC);


CREATE OR REPLACE FUNCTION transaction_operation(
    transaction_id UUID,
    cliente_id INT,
    value INT,
    tipo transactionType,
    description VARCHAR(10),
    transaction_created_at TIMESTAMPTZ,
    limite INT
)
RETURNS INT AS $$
DECLARE
    balance INT;
BEGIN
    -- Obtém o último saldo do cliente
    SELECT COALESCE(
      (SELECT last_balance
      FROM transactions t
      WHERE client_id = cliente_id  -- Substitua pelo ID do cliente desejado
      ORDER BY t.created_at DESC
      LIMIT 1),
      0
    ) INTO balance;

    balance := balance + CASE WHEN tipo = 'c' THEN value ELSE -value END;

    IF tipo = 'd' AND balance < -limite THEN
        RAISE EXCEPTION 'operation is not available: balance is below limit';
    END IF;

    -- Insere a nova transação
    INSERT INTO transactions (id, type, value, description, client_id, last_balance, created_at)
    VALUES (
      transaction_id, tipo, 
      value, description, 
      cliente_id, 
      balance, 
      transaction_created_at);

    RAISE NOTICE 'passei aqui 2';

    -- Retorna o novo saldo
    RETURN balance;


END;
$$ LANGUAGE plpgsql;
