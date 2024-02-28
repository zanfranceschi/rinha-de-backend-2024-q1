CREATE UNLOGGED TABLE clients (
    id SERIAL PRIMARY KEY,
    transfer_limit INTEGER NOT NULL,
    balance INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transactions (
    id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    valor INT NOT NULL,
    tipo TEXT NOT NULL,
    descricao TEXT NOT NULL,
    realizada_em TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now()) NOT NULL,
    CONSTRAINT fk_client_id FOREIGN KEY(client_id) REFERENCES clients(id)
);

CREATE UNIQUE INDEX idx_clients_id ON clients USING btree (id);

INSERT INTO clients (transfer_limit, balance)
VALUES
    (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);        