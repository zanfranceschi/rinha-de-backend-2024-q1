FROM gradle:latest AS build
RUN mkdir /src
COPY . /src
WORKDIR /src
RUN gradle clean build

FROM amazoncorretto:17-alpine3.19
COPY --from=build /src/build/libs/*.jar app.jar
ENV SPRING_PROFILES_ACTIVE develop
CMD $JAVA_HOME/bin/java -jar app.jar