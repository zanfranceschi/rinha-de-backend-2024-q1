/*
SQLyog Community
MySQL - 10.4.27-MariaDB : Database - rinha
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`rinha` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `rinha`;

/*Table structure for table `clientes` */

DROP TABLE IF EXISTS `clientes`;

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) DEFAULT NULL,
  `limite` int(11) NOT NULL,
  `saldo` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `clientes` */

insert  into `clientes`(`id`,`nome`,`limite`,`saldo`) values (1,'o barato sai caro',100000,0);
insert  into `clientes`(`id`,`nome`,`limite`,`saldo`) values (2,'zan corp ltda',80000,0);
insert  into `clientes`(`id`,`nome`,`limite`,`saldo`) values (3,'les cruders',1000000,0);
insert  into `clientes`(`id`,`nome`,`limite`,`saldo`) values (4,'padaria joia de cocaia',10000000,0);
insert  into `clientes`(`id`,`nome`,`limite`,`saldo`) values (5,'kid mais',500000,0);

/*Table structure for table `transacoes` */

DROP TABLE IF EXISTS `transacoes`;

CREATE TABLE `transacoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) NOT NULL,
  `valor` int(11) NOT NULL,
  `tipo` char(1) DEFAULT NULL,
  `descricao` varchar(10) DEFAULT NULL,
  `realizada_em` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  PRIMARY KEY (`id`),
  KEY `fk_transacao_cliente` (`cliente_id`),
  KEY `idx_realizada` (`realizada_em`),
  CONSTRAINT `fk_transacao_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `transacoes` */

/* Procedure structure for procedure `SalvarTransacoes` */

/*!50003 DROP PROCEDURE IF EXISTS  `SalvarTransacoes` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `SalvarTransacoes`(p_cliente_id INT, p_valor INT, p_tipo CHAR(1), p_descricao VARCHAR(10), OUT o_saldo INT, out o_limite int)
BEGIN	
	DECLARE diff INT;
        DECLARE res INT;    
        declare n_saldo int;    
        SET autocommit=0;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
        start transaction;
        
        IF (p_tipo='d') THEN
            SET diff = -p_valor;
        ELSE
            SET diff = p_valor;
        END IF;
        SELECT saldo, limite, saldo+diff into o_saldo, o_limite, n_saldo from clientes where id=p_cliente_id FOR UPDATE;
        if (n_saldo<-o_limite) then
            SET o_saldo=-1;
            set o_limite=-1;
            SELECT 'SALDO INDISPONIVEL' AS Msg;
            ROLLBACK;
        else        
            UPDATE clientes SET saldo = n_saldo WHERE id=p_cliente_id;               
            INSERT INTO transacoes (cliente_id, valor, tipo, descricao) VALUES (p_cliente_id, p_valor, p_tipo, p_descricao);
            SELECT saldo, limite INTO o_saldo, o_limite FROM clientes WHERE id=p_cliente_id;
            COMMIT;
        END IF;
	END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
