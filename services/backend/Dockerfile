# ==============================
# 1️⃣ BUILD STAGE
# ==============================
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom first (better cache)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source
COPY src ./src

# Build JAR (skip tests for image build)
RUN mvn clean package -DskipTests

# ==============================
# 2️⃣ RUNTIME STAGE
# ==============================
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/target/backend-0.0.1-SNAPSHOT.jar app.jar

# Expose Spring Boot port
EXPOSE 8000

# JVM optimizations for containers
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

# Run app
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
