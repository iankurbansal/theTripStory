# Simple Dockerfile for Railway deployment
FROM maven:3.9-openjdk-17-slim

# Set working directory
WORKDIR /app

# Copy backend files
COPY backend/pom.xml backend/api-spec.yaml ./
COPY backend/src ./src

# Build the application
RUN mvn clean package -DskipTests

# Copy the built JAR to expected location
RUN cp target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]