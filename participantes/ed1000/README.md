# Rinha de Backend, Segunda Edição: 2024/Q1


## Edmilson Figueiredo
Submissão feita com:
- `nginx` como load balancer
- `postgres` como banco de dados
- `java` SpringBoot 3.2.2 usando JdbcClient e compilado com native-image
- [repositório da api](https://github.com/edmilson1968/rinha-2024-q1)


## Criando a native-image

Super fácil pois estou usando o plugin do packeto https://github.com/dashaun/paketo-arm64

```
mvn clean package -Pnative spring-boot:build-image
```