# Submissão Eric Rosetti Lessa

Rinha de Backend 2024/01

## Stack

* Quarkus (web)
* Postgresql (banco de dados)
* nginx (proxy)

##### BUILD

./mvnw clean package -Dnative -Dquarkus.native.container-build=true

docker build -f src/main/docker/Dockerfile.native-micro -t ericlessa/rinha-backend-2401-quarkus .



## Repositório

* https://github.com/ericrlessa/rinha-backend-2401-quarkus
* ericrlessa@gmail.com


