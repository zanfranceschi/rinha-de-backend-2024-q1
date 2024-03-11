CREATE TYPE "transaction_types" AS ENUM ('c', 'd');

CREATE UNLOGGED TABLE clients (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL
);

CREATE UNLOGGED TABLE accounts (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	saldo INTEGER NOT NULL,
	limite INTEGER NOT NULL,
	CONSTRAINT fk_clients_saldos_id
		FOREIGN KEY (cliente_id) REFERENCES clients(id)
);

CREATE UNLOGGED TABLE transactions (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo "transaction_types" NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clients_transactions_id
		FOREIGN KEY (cliente_id) REFERENCES clients(id)
);

CREATE INDEX idx_clients_client_id ON clients ("id");
CREATE INDEX idx_accounts_client_id ON accounts ("cliente_id");
CREATE INDEX idx_transactions_client_id ON transactions ("cliente_id");

DO $$
BEGIN
    INSERT INTO clients (nome)
    VALUES
        ('o barato sai caro'),
        ('zan corp ltda'),
        ('les cruders'),
        ('padaria joia de cocaia'),
        ('kid mais');
    
    INSERT INTO accounts (cliente_id, saldo, limite)
    SELECT id, 0, 1000 * 100 FROM clients WHERE nome = 'o barato sai caro';
    
    INSERT INTO accounts (cliente_id, saldo, limite)
    SELECT id, 0, 800 * 100 FROM clients WHERE nome = 'zan corp ltda';
    
    INSERT INTO accounts (cliente_id, saldo, limite)
    SELECT id, 0, 10000 * 100 FROM clients WHERE nome = 'les cruders';
    
    INSERT INTO accounts (cliente_id, saldo, limite)
    SELECT id, 0, 100000 * 100 FROM clients WHERE nome = 'padaria joia de cocaia';
    
    INSERT INTO accounts (cliente_id, saldo, limite)
    SELECT id, 0, 5000 * 100 FROM clients WHERE nome = 'kid mais';
END;
$$;
