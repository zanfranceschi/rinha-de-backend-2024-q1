CREATE TABLE IF NOT EXISTS Cliente (
  id INT PRIMARY KEY,
  limite INT NOT NULL,
  saldo INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Transacao (
  id SERIAL PRIMARY KEY,
  idCliente INT REFERENCES Cliente(id) NOT NULL,
  valor INT NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  tipo CHAR(1) NOT NULL,
  realizadaEm TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Create indexes to speed up the queries
CREATE INDEX idx_transacao_idCliente ON Transacao (idCliente);
CREATE INDEX idx_transacao_realizadaEm ON Transacao (realizadaEm);

-- Create a function to handle the deletion of older transactions for a client
CREATE OR REPLACE FUNCTION delete_old_transactions() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM Transacao
    WHERE idCliente = NEW.idCliente
    AND id NOT IN (
        SELECT id FROM Transacao
        WHERE idCliente = NEW.idCliente
        ORDER BY realizadaEm DESC
        LIMIT 10
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to automatically delete older transactions after insertion
CREATE TRIGGER delete_old_transactions_trigger
AFTER INSERT ON Transacao
FOR EACH ROW
EXECUTE FUNCTION delete_old_transactions();

INSERT INTO Cliente (id, limite, saldo)
VALUES
  (1, 100000, 0),
  (2, 80000, 0),
  (3, 1000000, 0),
  (4, 10000000, 0),
  (5, 500000, 0);