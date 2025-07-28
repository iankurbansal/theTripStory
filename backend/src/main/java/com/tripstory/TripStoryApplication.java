package com.tripstory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

/**
 * Main application class for TripStory Backend
 * 
 * This Spring Boot application provides REST API endpoints for managing trips,
 * with automatic OpenAPI documentation generation and CORS support for frontend integration.
 */
@SpringBootApplication
@EnableJpaAuditing
public class TripStoryApplication {

    public static void main(String[] args) {
        SpringApplication.run(TripStoryApplication.class, args);
        
        System.out.println("🚀 TripStory Backend started successfully!");
        System.out.println("📚 API Documentation: http://localhost:8080/swagger-ui.html");
        System.out.println("🗄️  H2 Console: http://localhost:8080/h2-console");
        System.out.println("🌐 API Base URL: http://localhost:8080/api");
    }
}