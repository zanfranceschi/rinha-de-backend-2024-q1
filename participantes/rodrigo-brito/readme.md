# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência

<img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="300" height="auto">
<br />
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Go_Logo_Blue.svg/260px-Go_Logo_Blue.svg.png" alt="logo clojure" width="200" height="auto">
<br />
<img src="https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg" alt="logo postgres" width="200" height="auto">

## Rodrigo Brito

Submissão feita com:

- `nginx` como load balancer
- `postgres` como banco de dados
- `go` como linguagem
- [repositório da api](https://github.com/rodrigo-brito/rinha-backend-2024-q1)

## Recursos utilizados

- Router nativo (Mux)
- PGX (PostgreSQL)
- 2 Worker Async para SQL Insert
- Cache em memória (nativo)
- Controle de concorrência via mutexes (Lock / RLock)
- Oração :pray:

# Docker Stats

```
CONTAINER ID   NAME            CPU %     MEM USAGE / LIMIT   MEM %     NET I/O           BLOCK I/O        PIDS
ed3e7a383a9d   build-db-1      11.06%    99.18MiB / 200MiB   49.59%    6.35MB / 3.12MB   4.1kB / 3.35MB   9
bb155aa7f8d1   build-api01-1   22.64%    50.28MiB / 150MiB   33.52%    19MB / 200MB      0B / 0B          8
85acf5dcdbb7   build-api02-1   10.69%    53.93MiB / 150MiB   35.96%    12.8MB / 153MB    0B / 0B          8
0d7b89bc9101   build-nginx-1   10.39%    10.68MiB / 50MiB    21.35%    375MB / 378MB     0B / 12.3kB      5
```

## Resultados

![image](https://github.com/rodrigo-brito/rinha-backend-2024-q1/assets/7620947/65f1d7eb-4751-4136-aa52-efa7226959fe)

[@RodrigoFBrito](https://twitter.com/RodrigoFBrito) @ twitter
