DROP TABLE IF EXISTS `transaction`;
DROP TABLE IF EXISTS `account`;

CREATE TABLE `account`
(
    `id`             int UNSIGNED NOT NULL AUTO_INCREMENT,
    `holder_name`    varchar(100) NOT NULL,
    `limit_amount`   bigint       NOT NULL DEFAULT 0,
    `balance_amount` bigint       NOT NULL DEFAULT 0,
    `created_at`     timestamp(6)    NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `updated_at`     timestamp(6)    NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (`id`)
) CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_520_ci;


CREATE TABLE `transaction`
(
    `id`          bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id`  int UNSIGNED NOT NULL,
    `type_id`     enum('c','d') NOT NULL,
    `amount`      bigint       NOT NULL,
    `description` varchar(10)  NOT NULL,
    `created_at`  timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (`id`),
    INDEX         `account_id_idx`(`account_id`) USING BTREE,
    CONSTRAINT `transaction_account` FOREIGN KEY (`account_id`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_520_ci;
