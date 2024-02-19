FROM maven:3-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY . /app
RUN mvn package

FROM azul/zulu-openjdk-alpine:21
WORKDIR /app
COPY --from=build /app/target/rinha.jar .
ENTRYPOINT java -jar rinha.jar