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
	`created_at`	TIMESTAMP(6) NOT NULL,
	
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

DROP PROCEDURE IF EXISTS process_transaction;

DELIMITER $$
$$
CREATE PROCEDURE IF NOT EXISTS process_transaction(
	IN client_id INT,
	IN transaction_amount BIGINT,
	IN transaction_type VARCHAR(1),
	IN transaction_description VARCHAR(10)
)
main_process: BEGIN
	DECLARE client_limit BIGINT;
	DECLARE client_balance BIGINT;	
	DECLARE client_available_balance BIGINT;

	START TRANSACTION;

	SELECT
		c.limit,
		c.balance
	INTO 
		client_limit,
		client_balance 
	FROM clients AS c WHERE c.id = client_id FOR UPDATE;

	IF (transaction_type = 'c') THEN
		SET client_balance = client_balance + transaction_amount;
	ELSE
		SET client_available_balance = client_limit + client_balance;
		
		IF client_available_balance = 0 OR client_available_balance - transaction_amount < 0 THEN
			SELECT client_limit, client_balance, 'failure' AS transaction_status;
			ROLLBACK;			
			LEAVE main_process;
		END IF;
		
		SET client_balance = client_balance - transaction_amount;
	END IF;
	
	UPDATE clients SET balance = client_balance WHERE id = client_id;
	INSERT INTO transactions
		(client_id, amount, type, description, created_at)
	VALUES 
		(client_id, transaction_amount, transaction_type, transaction_description, utc_timestamp(6));
	
	SELECT client_limit, client_balance, 'success' AS transaction_status;
	COMMIT;	
END$$
DELIMITER ;