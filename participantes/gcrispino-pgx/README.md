# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência


<img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="300" height="auto">
<br />
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Go_Logo_Blue.svg/2880px-Go_Logo_Blue.svg.png" alt="logo golang" width="200" height="auto">
<img src="https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg" alt="logo postgres" width="200" height="auto">


## Gabriel Crispino - pgx
Tudo igual à submissão encontrada em https://github.com/zanfranceschi/rinha-de-backend-2024-q1/tree/main/participantes/gcrispino, mas trocando a biblioteca de driver postgres de [pq](https://github.com/lib/pq) para [pgx](https://github.com/jackc/pgx).
Submissão feita com:
- `nginx` como load balancer;
- `postgres` como banco de dados;
- `go` para api com as seguintes bibliotecas: 
    - [`echo`](https://echo.labstack.com/) para o servidor;
    -  [`go-json`](https://github.com/goccy/go-json/) para serialização de JSON no servidor;
    - [`pq`](https://github.com/lib/pq) como driver de Postgres;
    - [`automaxprocs`](https://github.com/uber-go/automaxprocs) para configurar automaticamente a variável de ambiente [`GOMAXPROCS`](https://dave.cheney.net/tag/gomaxprocs).
- [Repositório da api](https://github.com/GCrispino/rinha-2024/tree/pgx).

[@gabcrispino](https://twitter.com/gabcrispino) @ twitter
