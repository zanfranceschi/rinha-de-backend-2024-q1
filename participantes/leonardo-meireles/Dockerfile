#BUILD
FROM maven:3.8.3-openjdk-17-slim AS build
WORKDIR /usr/src/app
COPY . .
RUN mvn clean package -DskipTests

#RUN
FROM maven:3.8.3-openjdk-17-slim
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/target/rinha-backend-0.0.1-SNAPSHOT.jar app.jar
CMD ["java", "-jar", "app.jar"]
