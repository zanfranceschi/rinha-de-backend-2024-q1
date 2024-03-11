# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência

Uma API (vergonhosamente) completamente fora dos padrões de arquitetura, feita nas madrugadas da última semana, mas que tem o único objetivo de cumprir o propósito da competição, com foco na performance e consistência dos dados na concorrência transacional.

Tem suporte a bases PostgreSQL e MongoDB, sendo alternado entre um ou outro através da variável de ambiente `DATABASE_SELECTED`

## Repositório da API
[suricat89/rinha-go-suricat](https://github.com/suricat89/rinha-go-suricat)

## Tecnologias utilizadas

- `Golang 1.22`
  - `fiber/v3` como REST Framework
  - `pgx/v5` como lib PostgreSQL
  - `mongo-driver` como lib MongoDB
  - `go-redis/v9` como lib Redis cache
- `PostgreSQL` como BD relacional
- `MongoDB` como BD NoSQL
- `Redis` como cache (para controle de concorrência)

## Autor
- Thiago Monteiro de Paula
- [LinkedIn](https://www.linkedin.com/in/thiago-monteiro-de-paula-23ab2a88)
