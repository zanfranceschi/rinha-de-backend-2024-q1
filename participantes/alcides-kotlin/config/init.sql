-------------------------------------------
CREATE TABLE client
(
  id      SERIAL PRIMARY KEY,
  name    VARCHAR(50) NOT NULL,
  balance INT         NOT NULL DEFAULT 0,
  lmt     INT         NOT NULL
);
-------------------------------------------
CREATE TABLE transaction
(
  id          SERIAL PRIMARY KEY,
  client_id   INT REFERENCES client (id),
  value       INT         NOT NULL,
  type        CHAR(1)     NOT NULL,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  description VARCHAR(10) NOT NULL
);
-------------------------------------------
CREATE INDEX idx_client_id ON transaction (client_id);

CREATE INDEX idx_transactions_by_client_and_created_at
  ON transaction (client_id, created_at DESC);

-------------------------------------------
CREATE OR REPLACE FUNCTION register_debit(
  IN _client_id INT,
  IN _value INT,
  IN _description VARCHAR(10),
  OUT r_status CHAR(1),
  OUT r_lmt INT,
  OUT r_balance INT
)
  RETURNS record
AS
$$
BEGIN
  ----
  UPDATE client
  SET balance = balance - _value
  WHERE id = _client_id
    AND (balance + COALESCE(lmt, 0)) >= _value
  RETURNING COALESCE(lmt, 0), balance INTO r_lmt, r_balance;

  IF FOUND THEN
    INSERT INTO transaction (client_id, value, type, description)
    VALUES (_client_id, _value, 'd', _description);

    r_status := 'S'; -- Success
  ELSE

    IF EXISTS (SELECT 1 FROM client WHERE id = _client_id) THEN
      r_status := 'L'; -- NO_LIMIT
    ELSE
      r_status := 'N'; -- NOT_FOUND
    END IF;
  END IF;
END;
$$
  LANGUAGE plpgsql;

-------------------------------------------
CREATE OR REPLACE FUNCTION register_credit(
  IN _client_id INT,
  IN _value INT,
  IN _description VARCHAR(10),
  OUT r_status CHAR(1),
  OUT r_lmt INT,
  OUT r_balance INT
)
  RETURNS record
AS
$$
BEGIN

  UPDATE client
  SET balance = balance + _value
  WHERE id = _client_id
  RETURNING lmt, balance INTO r_lmt, r_balance;

  IF FOUND THEN
    INSERT INTO transaction (client_id, value, type, description)
    VALUES (_client_id, _value, 'c', _description);
    r_status := 'S'; -- Success
  ELSE
    r_status := 'N'; -- NOT_FOUND
  END IF;
END;
$$
  LANGUAGE plpgsql;
-------------------------------------------

INSERT INTO client (name, lmt)
VALUES ('o barato sai caro', 100000),
       ('zan corp ltda', 80000),
       ('les cruders', 1000000),
       ('padaria joia de cocaia', 10000000),
       ('kid mais', 500000);

-------------------------------------------
CREATE OR REPLACE FUNCTION reset_database()
  RETURNS VOID
AS
$$
BEGIN
  DELETE FROM transaction WHERE id <> 0;

  UPDATE client SET balance = 0, lmt = 100000 WHERE id = 1;
  UPDATE client SET balance = 0, lmt = 80000 WHERE id = 2;
  UPDATE client SET balance = 0, lmt = 1000000 WHERE id = 3;
  UPDATE client SET balance = 0, lmt = 10000000 WHERE id = 4;
  UPDATE client SET balance = 0, lmt = 500000 WHERE id = 5;
END;
$$ LANGUAGE plpgsql;
-------------------------------------------