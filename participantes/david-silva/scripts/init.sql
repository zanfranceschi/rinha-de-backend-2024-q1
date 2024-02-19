create unlogged table rinha.public.client
(
    id           integer not null
        constraint client_pk primary key,
    limit_cents  integer not null,
    amount       integer not null,
    transactions json
);

INSERT INTO public.client (id, limit_cents, amount) VALUES (1, 100000, 0);
INSERT INTO public.client (id, limit_cents, amount) VALUES (3, 1000000, 0);
INSERT INTO public.client (id, limit_cents, amount) VALUES (2, 80000, 0);
INSERT INTO public.client (id, limit_cents, amount) VALUES (5, 500000, 0);
INSERT INTO public.client (id, limit_cents, amount) VALUES (4, 10000000, 0);
