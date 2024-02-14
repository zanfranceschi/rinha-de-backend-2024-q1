CREATE table clients (
  id int primary key,
  c_limit int not null,
  balance int not null  
);

ALTER TABLE clients ADD CONSTRAINT check_balance_positive CHECK (balance >= (c_limit * -1));


CREATE table transactions (
  id int auto_increment primary key, 
  client_id int not null,
  value int not null,
  type varchar(1) not null,
  description varchar(10) not null,
  create_at TIMESTAMP(3) not null default current_timestamp,
  index (create_at  DESC),
  index (client_id) USING HASH
);

DELIMITER $$
CREATE PROCEDURE create_transaction(
  IN client_id int, 
  IN tx_value int,
  IN tx_type varchar(1),
  IN tx_desc varchar(10)
  )
BEGIN

    IF tx_type = 'c' THEN
      UPDATE clients set balance = balance + tx_value where id = client_id;
    ELSE
      UPDATE clients set balance = balance - tx_value where id = client_id;
    END IF;

    INSERT INTO transactions (client_id, value, type, description) VALUES 
      (client_id, tx_value, tx_type, tx_desc);
    
END $$


DELIMITER ;

START TRANSACTION;
insert into clients (id, c_limit, balance) 
values
  (1,100000, 0),
  (2,80000, 0),
  (3,1000000, 0),
  (4,10000000, 0),
  (5,500000, 0);
COMMIT;
