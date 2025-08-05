package com.tripstory.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Firebase configuration for the TripStory backend
 * 
 * Configures JWT token validation without Firebase Admin SDK
 * This approach works with organization policies that block service account key creation
 */
@Configuration
public class FirebaseConfig {

    @Bean
    public FirebaseJwtValidator firebaseJwtValidator() {
        String projectId = System.getenv("FIREBASE_PROJECT_ID");
        if (projectId == null) {
            System.err.println("FIREBASE_PROJECT_ID environment variable not set");
            projectId = "tripstory-1f299"; // fallback
        }
        
        System.out.println("Initializing Firebase JWT validator for project: " + projectId);
        return new FirebaseJwtValidator(projectId);
    }
}