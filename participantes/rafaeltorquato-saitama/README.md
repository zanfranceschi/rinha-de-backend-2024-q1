# rinha-backend-2024 Q1 (Saitama Version)
![death-punch.png](img/death-punch.png)

Projeto Java para a [Rinha de Backend 2024 Q1](https://github.com/zanfranceschi/rinha-de-backend-2024-q1).

[Repositório](https://github.com/rafaeltorquato/rinha-backend-2024/tree/saitama) com os fontes **branch saitama**.

**Saitama Version** - Versão que prioriza velocidade.

## Antes de começar
Dada as premissas da rinha, algumas decisões foram tomadas para deixar o projeto mais performático possível. 
Certas decisões não seriam tomadas em um projeto real, principalmente em projetos que tratam transações financeiras.

## Stack

* Java v21.0.2 Native image GraalVM;
  * Virtual Threads;
* Framework Quarkus v3.7.1;
* PostgreSQL v16;
  * Stored Procedures;
* HAProxy v2.9;
* JDBC;

## Executando o projeto
Run:
```shell script
docker compose up
```

## Resultado
A imagem abaixo contém o resultado da execução do gatling (25/02/2024) em um Ryzen 9 5900X 12 cores 24 threads, 64GB RAM DDR4 3600, NVME Gen 3.
![execucao.png](img/execucao.png)


## Contato
* [E-mail](mailto:rafaeltorquat0@prontonmail.com)
* [Linkedin](https://www.linkedin.com/in/rafaeltorquato/)
