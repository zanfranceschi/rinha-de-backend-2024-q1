CREATE TABLE IF NOT EXISTS clients (
    "id"                SERIAL,
    "name"              VARCHAR(50) NOT NULL,
    "limit"             INT NOT NULL,
    "balance"           INT DEFAULT 0,

    PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS transactions (
    "id"           SERIAL,
    "value"        INT NOT NULL,
    "type"         VARCHAR(1) NOT NULL,
    "description"  VARCHAR(10) NOT NULL,
    "created_at"   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    "client_id"    INT NOT NULL,

    CONSTRAINT "clients_fk" FOREIGN KEY ("client_id") REFERENCES clients("id")
);


DO $$
BEGIN
  INSERT INTO clients ("name", "limit")
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$

