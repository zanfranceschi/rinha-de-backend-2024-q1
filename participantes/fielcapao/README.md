# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência


<img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="300" height="auto">
<br />
<img src="https://upload.wikimedia.org/wikipedia/commons/f/f1/GraalVM_Logo_RGB.svg" alt="logo cassandra" width="200" height="auto">
<img src="https://upload.wikimedia.org/wikipedia/commons/7/79/Spring_Boot.svg" alt="logo spring boot 3" width="200" height="auto">
<img src="https://upload.wikimedia.org/wikipedia/commons/5/5e/Cassandra_logo.svg" alt="logo cassandra" width="200" height="auto">

## Rodrigo Rodrigues
Submissão feita com:
- `nginx` como load balancer
- `cassandra` como banco de dados
- `java 21 - graalvm - native image` com `spring boot 3`.
- [repositório da api](https://github.com/rodrigorodrigues/rinha-de-backend-2024-q1-javaslow-spring)

[@fielcapao](https://twitter.com/fielcapao) @ twitter


## Installation

Pra gerar a image native `mvn clean package -Pnative spring-boot:build-image` e precisa [GraalVM 21](https://www.graalvm.org/downloads/)

Pra gerar somente a docker image use `mvn clean package spring-boot:build-image`.

## Execution

`docker-compose up -d` precisa esperar um pouco ate Cassandra subir(use pra saber quando API is ready http://localhost:9999/actuator/health)
