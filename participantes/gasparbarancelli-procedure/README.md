## Gaspar Barancell Junior


## Rinha de Backend 2024

Aplicação desenvolvida em Quarkus com VirtualThreads, compilando imagem nativa utilizando a GraalVM, utilizando o Postgres como banco de dados e o Nginx como proxy.

Nessa versão eu não utilizei bloqueio pessimista, fiz a operação tudo em uma procedure fazendo o update no saldo do cliente validando o limite.


##### BUILD

./mvnw clean package -DskipTests -Dnative -Dquarkus.native.container-build=true -Dquarkus.container-image.build=true

docker build -f src/main/docker/Dockerfile.native-micro -t gasparbarancelli/rinha-backend-2024-procedure:latest .


##### Repositorio Oficial

https://github.com/gasparbarancelli/rinha-backend-2024/tree/feature/procedure
https://twitter.com/gasparbjr
https://br.linkedin.com/in/gaspar-barancelli-junior-77681881