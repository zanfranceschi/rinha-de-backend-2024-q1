## Gaspar Barancell Junior


## Rinha de Backend 2024

Aplicação desenvolvida em Quarkus com VirtualThreads, compilando imagem nativa utilizando a GraalVM, utilizando o H2 como banco de dados e o Envoy como proxy.


##### BUILD

./mvnw clean package -DskipTests -Dnative -Dquarkus.native.container-build=true -Dquarkus.container-image.build=true

docker build -f src/main/docker/Dockerfile.native-micro -t gasparbarancelli/rinha-backend-2024-h2:latest .


##### Repositorio Oficial

https://github.com/gasparbarancelli/rinha-backend-2024/tree/feature/h2
https://twitter.com/gasparbjr
https://br.linkedin.com/in/gaspar-barancelli-junior-77681881