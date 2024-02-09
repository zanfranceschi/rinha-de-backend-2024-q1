#!/bin/bash

export QUARKUS_DATASOURCE_JDBC_URL="jdbc:postgresql://localhost:5432/postgres"
export QUARKUS_DATASOURCE_USERNAME="gitpod"
export QUARKUS_DATASOURCE_PASSWORD="gitpod"

if [ ! -f "target/quarkus-app/quarkus-run.jar" ]; then
  mvn package
fi

java -jar target/quarkus-app/quarkus-run.jar
