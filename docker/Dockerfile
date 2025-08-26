# Use Maven image to build
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy entire backend directory structure
COPY backend/ .

# Debug: List files to make sure everything is copied
RUN ls -la
RUN cat pom.xml | head -20

# Build with verbose output to see what's failing
RUN mvn clean package -DskipTests -X

# Use lightweight JRE for runtime
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]