
CREATE SCHEMA IF NOT EXISTS `rinha_backend` DEFAULT CHARACTER SET utf8 ;
USE `rinha_backend` ;

CREATE TABLE IF NOT EXISTS `rinha_backend`.`Cliente` (
  `id` INT(1) UNSIGNED NOT NULL,
  `limite` INT(9) NOT NULL,
  `saldo` INT(9) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `rinha_backend`.`Transacao` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idCliente` INT(1) UNSIGNED NOT NULL,
  `valor` INT(9) NOT NULL,
  `descricao` VARCHAR(10) NOT NULL,
  `tipo` ENUM('c', 'd') NOT NULL,
  `realizada_em` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`, `idCliente`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_Transacao_Cliente_idx` (`idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Transacao_Cliente`
    FOREIGN KEY (`idCliente`)
    REFERENCES `rinha_backend`.`Cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


INSERT INTO `rinha_backend`.`Cliente` (id, limite, saldo)
VALUES
  (1, 100000, 0),
  (2, 80000, 0),
  (3, 1000000, 0),
  (4, 10000000, 0),
  (5, 500000, 0);
