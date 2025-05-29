FROM eclipse-temurin:17-jdk-alpine
LABEL authors="AhmedHassanIbrahim"

WORKDIR /app
COPY target/calendar-conflict-optimizer-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
