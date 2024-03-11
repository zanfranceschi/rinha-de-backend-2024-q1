-- Add up migration script here
CREATE TABLE wallet (
    id SERIAL PRIMARY KEY,
    "limit" INTEGER NOT NULL,
    total INTEGER DEFAULT 0 NOT NULL,
    CHECK (- total <= "limit")
);
CREATE INDEX wallet_limit_total_index ON wallet(id,"limit",total);

-- Create enum
CREATE TYPE transaction_type AS ENUM ('c', 'd');

CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    wallet_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    "type" transaction_type NOT NULL,
    "description" VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (wallet_id) REFERENCES wallet(id)
);

CREATE INDEX wallet_id_index ON transaction(wallet_id);

INSERT INTO wallet ("limit", total) VALUES (100000, 0);
INSERT INTO wallet ("limit", total) VALUES (80000, 0);
INSERT INTO wallet ("limit", total) VALUES (1000000, 0);
INSERT INTO wallet ("limit", total) VALUES (10000000, 0);
INSERT INTO wallet ("limit", total) VALUES (500000, 0);