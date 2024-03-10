INSERT INTO "clients"("id","limit")
VALUES
	(1, 100000),
	(2, 80000),
	(3, 1000000),
	(4, 10000000),
	(5, 500000);

ALTER SEQUENCE "clients_id_seq" RESTART WITH 6;