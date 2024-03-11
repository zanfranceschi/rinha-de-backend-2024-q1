# Rinha de Backend - 2ª Edição

Repositório do código desenvolvido para a segunda edição da rinha de backend.

Repositório da API: <https://github.com/jjeanjacques10/rinhabackend-2024-q1>

## Tecnologias

- Kotlin
- Spring Boot 3
- Postgresql
- Graalvm

## Getting Started

### Spring

Para começar a editar localmente, primeiro execute o container do banco de dados utilizando o seguinte comando:

``` shell
docker-compose -f docker-compose-database.yml up -d
```

E então rode em sua IDE o projeto ou execute os seguintes comandos:

``` shell
cd app
mvn clean install
```

Após a compilação bem-sucedida com o comando mvn clean install, você pode executar o projeto usando o arquivo JAR
gerado. Utilize o seguinte comando:

``` shell
java -jar app/target/rinhabackend-0.0.1-SNAPSHOT.jar
```

Ou execute o arquivo [run_spring_boot_with_spring.sh](run_spring_boot_with_spring.sh)

## Graalvm

Configurando o [Graalvm](https://www.youtube.com/watch?v=8umoZWj6UcU) para resolver o problema de memória.

``` shell
mvn -Pnative spring-boot:build-image
docker run --rm -p 8080:8080 docker.io/library/rinhabackend-0.0.1-SNAPSHOT
```

Ou execute o arquivo [run_spring_boot_with_graalvm.sh](run_spring_boot_with_graalvm.sh)

## Resultado

Resultado utilizando Graalvm

![Resultado utilizando Graalvm](https://raw.githubusercontent.com/jjeanjacques10/rinhabackend-2024-q1/main/images/Gatlin-Graalvm.png)

Algo muito interessante foi observar o uso de memória das duas abordagens

- **Spring**
    - Usei um container maior (600MB) para realizar os testes no spring padrão por que pelas regras do desafio o valor
      determinado não conseguia
      nem manter a aplicação rodando.
      ![Resultado utilizando Graalvm](https://raw.githubusercontent.com/jjeanjacques10/rinhabackend-2024-q1/main/images/Docker-Spring-High-Memory.png)

- **Graalvm - Nativo**
    - Rodando de forma nativa com 150MB (ou até menos) consegui rodar sem problemas os testes.
      ![Resultado utilizando Graalvm](https://raw.githubusercontent.com/jjeanjacques10/rinhabackend-2024-q1/main/images/Docker-Graalvm.png)

## Sobre a Rinha

A Rinha de Backend é uma competição onde desenvolvedores demonstram suas habilidades para melhorar a performance de
aplicações.

Para mais informações e regras, acesse o repositório oficial da Rinha de
Backend: [Rinha de Backend - GitHub](https://github.com/zanfranceschi/rinha-de-backend-2024-q1)