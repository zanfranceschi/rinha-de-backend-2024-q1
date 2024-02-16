CREATE TABLE IF NOT EXISTS clients(
	`id` 			INT NOT NULL,
	`limit` 		BIGINT NOT NULL,
	`balance` 		BIGINT DEFAULT 0,	
	PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS transactions (
	`id` 			INT NOT NULL AUTO_INCREMENT,
	`client_id`     INT NOT NULL,
	`amount`		BIGINT NOT NULL,
	`type`			VARCHAR(1) NOT NULL,
	`description`	VARCHAR(10) NOT NULL,
	`created_at`	TIMESTAMP NOT NULL,
	
	PRIMARY KEY (`id`),
	CONSTRAINT transaction_client_id_fk FOREIGN KEY (`client_id`) REFERENCES clients(`id`),
	INDEX transaction_created_at_idx (`created_at`)
) ENGINE=InnoDB;

INSERT INTO clients(`id`, `limit`)
VALUES 
	(1, 100000),
	(2, 80000),
	(3, 1000000),
	(4, 10000000),
	(5, 500000);