CREATE TABLE IF NOT EXISTS "clients" (
  "id"      SERIAL PRIMARY KEY,
  "name"    VARCHAR(50) NOT NULL,
  "limit"   INT NOT NULL,
  "balance" INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "transaction" (
  "id"          SERIAL PRIMARY KEY,
  "value"       INT NOT NULL,
  "type"        VARCHAR(2) NOT NULL, -- CHECK(type IN ('c', 'd')),
  "description" VARCHAR(10) NOT NULL,
  "created_at"  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "client_id"   INT NOT NULL REFERENCES clients("id")
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
END; $$;
