## Gaspar Barancell Junior


## Rinha de Backend 2024

Aplicação desenvolvida em Quarkus com VirtualThreads, compilando imagem nativa utilizando a GraalVM, utilizando o Postgres como banco de dados e o Nginx como proxy.


##### BUILD

./mvnw clean package -DskipTests -Dnative -Dquarkus.native.container-build=true -Dquarkus.container-image.build=true

docker build -f src/main/docker/Dockerfile.native-micro -t gasparbarancelli/rinha-backend-2024-nginx:latest .


##### Repositorio Oficial

https://github.com/gasparbarancelli/rinha-backend-2024/tree/feature/nginx
https://twitter.com/gasparbjr
https://br.linkedin.com/in/gaspar-barancelli-junior-77681881