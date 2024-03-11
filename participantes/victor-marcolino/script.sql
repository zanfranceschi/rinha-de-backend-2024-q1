-- Drop the table if it already exists
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS transactions;


-- Create the table
CREATE TABLE clients
(
    "uuid"    VARCHAR(36) PRIMARY KEY,
    "limit"   BIGINT NOT NULL,
    "balance" BIGINT NOT NULL
);
-- Create the table
CREATE TABLE IF NOT EXISTS transactions
(
    uuid        VARCHAR(36) PRIMARY KEY,
    client_uuid VARCHAR(36) NOT NULL,
    value       BIGINT      NOT NULL,
    description TEXT        NOT NULL,
    type        CHAR(1)     NOT NULL CHECK (type IN ('c', 'd')),
    created_at  BIGINT      NOT NULL
);

-- Insert the data
INSERT INTO clients ("uuid", "limit", "balance")
VALUES (1, 100000, 0),
       (2, 80000, 0),
       (3, 1000000, 0),
       (4, 10000000, 0),
       (5, 500000, 0);