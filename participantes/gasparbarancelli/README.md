## Gaspar Barancell Junior


## Rinha de Backend 2024

Aplicação desenvolvida em Quarkus com VirtualThreads, compilando imagem nativa utilizando a GraalVM.

Utilizei o banco de dados Postgres e o Nginx como proxy.

* Inicialmente iria utilizar o banco de dados mysql mas o Postgres teve menor consumo de memoria e cpu.


##### BUILD

./mvnw clean package -DskipTests -Dnative -Dquarkus.native.container-build=true -Dquarkus.container-image.build=true

docker build -f src/main/docker/Dockerfile.native-micro -t gasparbarancelli/rinha-backend-2024:latest .


##### Repositorio Oficial

https://github.com/gasparbarancelli/rinha-backend-2024