CREATE TABLE IF NOT EXISTS clientes (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    limite INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS transacoes (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo TEXT NOT NULL,
    descricao TEXT NOT NULL,
    realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE IF NOT EXISTS saldos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX id_index ON clientes (id);
CREATE INDEX id_cliente_transacoes_index ON transacoes (cliente_id);
CREATE INDEX id_cliente_saldos_index ON saldos (cliente_id);

INSERT INTO clientes (nome, limite)
	VALUES
		('ze da manga', 1000 * 100),
		('vai neymar', 800 * 100),
		('loteria', 10000 * 100),
		('nossa', 100000 * 100),
		('o que? como?', 5000 * 100);
	
INSERT INTO saldos (cliente_id, valor)
    SELECT id, 0 FROM clientes;
