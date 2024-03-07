# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência

<img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="300" height="auto">
<br />
<img src="https://logodix.com/logo/700854.png" alt="logo rust" width="200" height="auto">
<img src="https://ntex.rs/img/logo.png" alt="logo ntex" width="100" height="auto">
<img src="https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg" alt="logo postgres" width="200" height="auto">


## Gabriel Messias Costa
Submissão feita com:
- `nginx` como load balancer
- `postgres` como banco de dados
- `rust` como linguagem 
- [ntex](https://ntex.rs/) como web framework
- `tokio-postgres` como driver de conexão de banco

## Repositório
https://github.com/ThusSpokeBieu/rinha-crebito-rust

## Redes
[@ThusSpokeBieu](https://twitter.com/thusspokebieu) @ twitter

[@gmessiasc](https://www.linkedin.com/in/gmessiasc/) @ Gabriel Messias Costa | LinkedIn

## Como rodar: 

docker compose up 

A api vai avisar que está se alongando e vai avisar quando estiver pronta pra receber requisição com um console log bacana.

## Créditos:

Peguei várias ideias legais de configurações de infra de vários repositórios, em especial: 

- https://github.com/viniciusfonseca/rinha-backend-rust-2

- https://github.com/gabrielluciano/rinha-backend-2024-q1-vertx

Muitas ideias tiradas do benchmark do techempower do ntex:

- https://github.com/TechEmpower/FrameworkBenchmarks/blob/master/frameworks/Rust/ntex
