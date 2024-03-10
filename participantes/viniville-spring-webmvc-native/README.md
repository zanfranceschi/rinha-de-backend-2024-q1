# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência

## Vinicius Ville
Submissão feita com:
- `nginx`
- `postgres`
- `java 21`
- `Spring Boot 3 - Web MVC`

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![Spring](https://img.shields.io/badge/Spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)

[Repositório da API](https://github.com/viniville/rinhabackend-2024q1-spring-webmvc)\
[Linkedin](www.linkedin.com/in/vinicius-ville)

## Compilação e Execução
```
export JAVA_HOME=[path jdk 21]
./mvnw spring-boot:run 
```
## Build Docker Image
```
docker build --build-arg JAR_FILE=target/*.jar -t viniville/rinhabackend-sb-webmvc-2024-q1:latest .
```

## [GraalVM] - Compilação Nativa e Execução
```
export JAVA_HOME=[path jdk 21 GraalVM]
./mvnw -DskipTests -Pnative native:compile
./target/rinhabackend-webmvc
```

## [GraalVM] Build Docker Image - With Native App
```
docker build --build-arg APP_EXE=target/rinhabackend-webmvc -t viniville/rinhabackend-sb-webmvc-native-2024-q1:latest . -f Dockerfile-native
```
## [Docker Compose] Executar infraestrutura completa
```
cd ./.infra/
# Aplicacao rodando na JVM - Java Runtime
docker compose up

# Aplicacao Nativa
docker compose -f docker-compose-native.yml up
```