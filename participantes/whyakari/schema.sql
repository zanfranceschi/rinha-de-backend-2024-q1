CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    saldo INT NOT NULL,
    limite INT NOT NULL
);

CREATE TABLE IF NOT EXISTS transacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    valor INT NOT NULL,
    id_cliente INT NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO clientes (nome, limite, saldo) VALUES
	('Akari', 100000 * 100, 0),
	('Isabella', 80000 * 100, 0),
	('Julia', 1000000 * 100, 0),
	('Hendrick', 10000000 * 100, 0),
	('Gustavo', 500000 * 100, 0);
