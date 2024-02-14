# Rinha de Backend 2024 Q1 - Controle de Concorrência

Esta é uma aplicação em Golang desenvolvida com o framework Gin, utiliza o banco de dados PostgreSQL e NGINX. A aplicação é destinada a participar da [Rinha de Backend 2024 Q1](https://github.com/zanfranceschi/rinha-de-backend-2024-q1) com o tema de controle de concorrência.

## Funcionalidades

A aplicação possui dois endpoints:

1.  **POST /clientes/[id]/transacoes**: Este endpoint permite registrar transações para um cliente específico. Requer um corpo JSON com os seguintes campos:

```json
{
  "valor": 1000,

  "tipo": "c",

  "descricao": "descricao"
}
```

- `valor`: O valor da transação.

- `tipo`: O tipo de transação (por exemplo, "c" para crédito).

- `descricao`: Descrição da transação.

2.  **GET /clientes/[id]/extrato**: Este endpoint permite obter o extrato de transações de um cliente específico.

## Execução

Execute o seguinte comando na raiz do projeto e faça as requisições na porta 9999.

```bash

docker-compose  up  -d

```

## Stack

- [Go 1.21](https://go.dev/)

- [Gin Web Framework](https://github.com/gin-gonic/gin)

- [PostgreSQL](https://www.postgresql.org/)

- [NGINX](https://www.nginx.com/)

---

##### Isadora Moysés de Souza

##### [Repositório no github](https://github.com/isadoramsouza/rinha-backend-go-2024-q1)

##### [Linkedin](https://br.linkedin.com/in/isadora-souza?original_referer=https%3A%2F%2Fwww.google.com%2F)

##### [Twitter](https://twitter.com/isadoraamsouza)
