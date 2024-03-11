ALTER DATABASE rinha SET log_error_verbosity to 'TERSE';

CREATE UNLOGGED TABLE ledger (
  id SERIAL PRIMARY KEY,
  client_id INTEGER NOT NULL,
  client_limit INTEGER NOT NULL,
  client_balance INTEGER NOT NULL,
  transaction_value INTEGER NOT NULL,
  transaction_type CHAR NOT NULL,
  transaction_description VARCHAR(10) NOT NULL,
  client_transaction_count INTEGER DEFAULT 0,
  is_seed_transaction BOOLEAN DEFAULT FALSE,
  create_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX idx_ledger_client_id_client_transaction_count ON ledger (client_id, client_transaction_count DESC);
CREATE INDEX idx_ledger_client_transaction_count ON ledger (client_transaction_count DESC);
