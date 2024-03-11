SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `transaction`;
TRUNCATE TABLE `account`;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO `account` (`holder_name`, `limit_amount`)
VALUES ('Ragnar', 1000 * 100),
       ('Lagertha', 800 * 100),
       ('Björn', 10000 * 100),
       ('Floki', 100000 * 100),
       ('Athelstan', 5000 * 100);