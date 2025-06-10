FROM maven:3.8.3-openjdk-17 AS MAVEN_BUILD
LABEL authors="AhmedHassanIbrahim"

COPY pom.xml /build/
COPY src /build/src/

WORKDIR /build/
RUN mvn -DskipTests -Pdev clean package
# RUN mvn -Pdev clean package

FROM openjdk:17-jdk-alpine
RUN apk add --no-cache tzdata

WORKDIR /app
RUN apk update
RUN apk add net-tools
RUN apk add less

COPY --from=MAVEN_BUILD /build/target/calendar-conflict-optimizer-0.0.1-SNAPSHOT.jar .

ENTRYPOINT ["java", "-jar", "calendar-conflict-optimizer-0.0.1-SNAPSHOT.jar"]
