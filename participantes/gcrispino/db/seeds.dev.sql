INSERT INTO customers ("limit", balance)
VALUES
    (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);

INSERT INTO transactions (value, type, description, customer_id)
VALUES
    (9000, 'c', NULL, 1),
    (50, 'c', NULL, 1),
    (100, 'd', NULL, 1),
    (50, 'c', NULL, 2),
    (100, 'c', NULL, 2);

UPDATE customers SET balance=8950 WHERE id=1;
UPDATE customers SET balance = -50 WHERE id = 2;