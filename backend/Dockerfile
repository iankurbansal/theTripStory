# Multi-stage Dockerfile for TripStory Backend (Spring Boot)

# Stage 1: Build the application  
FROM maven:3.8-openjdk-17 AS builder

# Set working directory
WORKDIR /app

# Copy pom.xml first (for better layer caching)
COPY pom.xml .
COPY api-spec.yaml .

# Download dependencies (this layer will be cached if pom.xml doesn't change)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application (skip tests for faster builds)
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM openjdk:17-jre-slim

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create app user for security
RUN useradd --create-home --shell /bin/bash app

# Set working directory
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Change ownership to app user
RUN chown app:app app.jar

# Switch to app user
USER app

# Expose port 8080
EXPOSE 8080

# Health check removed for Cloud Run compatibility

# Environment variables optimized for Cloud Run
ENV JAVA_OPTS="-Xmx512m -Xms256m -XX:+UseContainerSupport -XX:MaxRAMPercentage=75"

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

# Labels for better container management
LABEL maintainer="TripStory Team" \
      version="1.0.0" \
      description="TripStory Backend API - Spring Boot application for managing travel trips"