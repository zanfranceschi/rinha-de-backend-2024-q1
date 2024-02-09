# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência

<img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="300" height="auto">
<br />
<br />
<img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Go_Logo_Blue.svg" alt="logo go(lang)" width="200" height="auto">
<br/>
<img src="https://brandlogos.net/wp-content/uploads/2021/11/postgresql-logo.png" alt="logo postgres" width="200" height="auto">

## Germano (nyxawaits)

Usado:

- `nginx` como load balancer
- `postgres` como banco de dados
- `go` para api, usando `database/sql` nativo e `fiber` para roteamento
- [repositório](https://github.com/STNeto1/rinha-de-banco)

[@nyxawaits](https://twitter.com/nyxawaits) @ twitter

---

### Fatos estranhos do feito

Pelo que eu testei, no momento está database bounded =D

| Description       | Total responses | # Slowest | # Avg | # Fastest |
| ----------------- | --------------- | --------- | ----- | --------- |
| Qualquer          | 5491            | 3.39s     | 0.54s | 0.0004s   |
| Baseline \*       | 5270            | 2.99s     | 0.56s | 0.0004s   |
| Tunned to DB      | 14336           | 4.46s     | 0.20s | 0.0004s   |
| Focused on the DB | 15441           | 1.08s     | 0.19s | 0.0004s   |

\* -> Feito com as configurações iniciais do docker-compose.yml

- Ferramenta usada: Oha
- Comando: `oha -n 200000 -z 60s --rand-regex-url  http://127.0.0.1:9999/clientes/[1-5]/extrato`
