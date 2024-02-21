DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS transacoes;

CREATE TABLE clientes(
    id int auto_increment primary key,
    limite int not null,
    saldo int not null,
    data_criacao timestamp default current_timestamp()
) ENGINE=INNODB;

insert into clientes (limite, saldo)
values
(100000, 0), 
(80000, 0),
(1000000, 0),
(10000000, 0),
(500000, 0);

CREATE TABLE transacoes(
    id int auto_increment primary key,
    valor int not null,
    tipo char(1) not null,
    descricao varchar(12) not null,
    realizada_em timestamp default current_timestamp(),
    cliente_id int not null,
    FOREIGN KEY (cliente_id)
    REFERENCES clientes(id)
    ON DELETE CASCADE
) ENGINE=INNODB;