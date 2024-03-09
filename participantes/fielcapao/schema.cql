DROP KEYSPACE IF EXISTS rinha;

CREATE KEYSPACE IF NOT EXISTS rinha WITH REPLICATION = {'class':'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE rinha.accounts_balance (
    accountId int,
    temporary counter,
    total counter,
    PRIMARY KEY (accountId)
) WITH compression = {'class': 'LZ4Compressor', 'chunk_length_in_kb': 2, 'crc_check_chance': 0.1};

CREATE TABLE IF NOT EXISTS rinha.transactions (
    accountId int,
    type text,
    description text,
    date timestamp,
    amount int,
    dateMillis bigint,
    PRIMARY KEY ((accountId), dateMillis)
) WITH CLUSTERING ORDER BY (dateMillis DESC) AND compression = {'class': 'LZ4Compressor', 'chunk_length_in_kb': 2, 'crc_check_chance': 0.1};

UPDATE rinha.accounts_balance SET total = total + 0 WHERE accountId = 1;
UPDATE rinha.accounts_balance SET total = total + 0 WHERE accountId = 2;
UPDATE rinha.accounts_balance SET total = total + 0 WHERE accountId = 3;
UPDATE rinha.accounts_balance SET total = total + 0 WHERE accountId = 4;
UPDATE rinha.accounts_balance SET total = total + 0 WHERE accountId = 5;
