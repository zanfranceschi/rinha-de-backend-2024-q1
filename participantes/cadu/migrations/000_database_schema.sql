--
-- Initial database bootstrap for "Rinha de Backend 2024-Q1"
--

-- Table names and fields will be as abbreviated as possible to save bytes over the wire.

--
-- Clients table
--
CREATE TABLE c (
    -- ID
    i SMALLSERIAL PRIMARY KEY,
    -- Credit Limit
    l BIGINT NOT NULL,
    -- Current Balance
    b BIGINT NOT NULL DEFAULT 0
);


--
-- Transactions table
--
CREATE TABLE t (
    -- ID
    i SERIAL PRIMARY KEY,
    -- Client ID, foreign key to c.i
    c SMALLSERIAL NOT NULL,
    -- CONSTRAINT fk_c FOREIGN KEY (c) REFERENCES c(i), -- Nope!
    -- Amount
    a BIGINT NOT NULL,
    -- Operation: [c]redit or [d]ebit
    o CHAR(1) NOT NULL,
    -- Description: max 10, nullable
    d VARCHAR(10),
    -- Timestamp
    t TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

