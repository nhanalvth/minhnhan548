FROM maven:3.9.0-eclipse-temurin-17 as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM eclipse-temurin:17.0.6_10-jdk
WORKDIR /app
RUN mkdir -p /apps
COPY --from=build /app/target/demoapp-1.0.0.jar /apps/demoapp.jar
EXPOSE 8080
CMD ["java", "-jar", "/apps/demoapp.jar"]