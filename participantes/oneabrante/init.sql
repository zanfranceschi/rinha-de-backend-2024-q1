USE rinhadb;

-- CreateTable
CREATE TABLE `cliente` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(191) NOT NULL,
    `limite` INTEGER NOT NULL,
    `saldo` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `transacao` (
    `id` VARCHAR(191) NOT NULL,
    `valor` INTEGER NOT NULL,
    `tipo` VARCHAR(191) NOT NULL,
    `descricao` VARCHAR(191) NOT NULL,
    `realizada_em` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `clienteId` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `transacao` ADD CONSTRAINT `transacao_clienteId_fkey` FOREIGN KEY (`clienteId`) REFERENCES `cliente`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- InsertData(seeds)
INSERT INTO `cliente` (`id`, `nome`, `limite`, `saldo`) VALUES
(1, 'o barato sai caro', 1000 * 100, 0),
(2, 'zan corp ltda', 800 * 100, 0),
(3, 'les cruders', 10000 * 100, 0),
(4, 'padaria joia de cocaia', 100000 * 100, 0),
(5, 'kid mais', 5000 * 100, 0);