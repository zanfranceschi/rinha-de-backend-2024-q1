CREATE TABLE clients (
     id SERIAL PRIMARY KEY,
     saldo INTEGER NOT NULL DEFAULT 0, 
     limite INTEGER NOT NULL
);


INSERT INTO clients (id, limite)
VALUES (1, 100000),
       (2, 80000),
       (3, 1000000),
       (4, 10000000),
       (5, 500000);


CREATE TABLE event_journal (
	ordering BIGSERIAL NOT NULL PRIMARY KEY,
    persistence_id VARCHAR(255) NOT NULL,
    sequence_nr BIGINT NOT NULL,
    is_deleted BOOLEAN NOT NULL,
    created_at BIGINT NOT NULL,
    manifest VARCHAR(500) NOT NULL,
    payload BYTEA NOT NULL,
    tags VARCHAR(100) NULL,
    serializer_id INTEGER NULL,
    CONSTRAINT event_journal_uq UNIQUE (persistence_id, sequence_nr)
);

CREATE TABLE snapshot_store (
    persistence_id VARCHAR(255) NOT NULL,
    sequence_nr BIGINT NOT NULL,
    created_at BIGINT NOT NULL,
    manifest VARCHAR(500) NOT NULL,
    payload BYTEA NOT NULL,
    serializer_id INTEGER NULL,
    CONSTRAINT snapshot_store_pk PRIMARY KEY (persistence_id, sequence_nr)
);

CREATE TABLE metadata (
    persistence_id VARCHAR(255) NOT NULL,
    sequence_nr BIGINT NOT NULL,
    CONSTRAINT metadata_pk PRIMARY KEY (persistence_id, sequence_nr)
);
