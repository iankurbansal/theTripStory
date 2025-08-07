package com.tripstory.util;

import com.tripstory.entity.Trip;
import com.tripstory.entity.Destination;
import com.tripstory.model.CreateTripRequest;
import com.tripstory.model.UpdateTripRequest;
import org.springframework.stereotype.Component;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;

@Component
public class TripConverter {
    
    public com.tripstory.model.Trip toModel(Trip entity) {
        if (entity == null) {
            return null;
        }
        
        com.tripstory.model.Trip model = new com.tripstory.model.Trip();
        model.setId(entity.getId());
        model.setTitle(entity.getTitle());
        model.setStartDate(entity.getStartDate());
        model.setEndDate(entity.getEndDate());
        model.setNotes(entity.getNotes());
        model.setImageUrl(entity.getImageUrl());
        model.setImageAttribution(entity.getImageAttribution());
        
        if (entity.getCreatedAt() != null) {
            model.setCreatedAt(entity.getCreatedAt().atOffset(ZoneOffset.UTC));
        }
        if (entity.getUpdatedAt() != null) {
            model.setUpdatedAt(entity.getUpdatedAt().atOffset(ZoneOffset.UTC));
        }
        
        return model;
    }
    
    public Trip fromCreateRequest(CreateTripRequest request) {
        if (request == null) {
            return null;
        }
        
        Trip entity = new Trip();
        entity.setTitle(request.getTitle());
        entity.setStartDate(request.getStartDate());
        entity.setEndDate(request.getEndDate());
        entity.setNotes(request.getNotes());
        
        // For now, we'll create a basic destination from the title for Unsplash integration
        // This is a temporary solution until we have proper destination management
        if (request.getTitle() != null && !request.getTitle().trim().isEmpty()) {
            Destination destination = new Destination();
            destination.setName(extractDestinationFromTitle(request.getTitle()));
            destination.setOrderIndex(0);
            entity.addDestination(destination);
        }
        
        return entity;
    }
    
    private String extractDestinationFromTitle(String title) {
        // Simple extraction logic - look for common patterns
        // "Trip to Paris" -> "Paris"
        // "Paris Adventure" -> "Paris"
        // "Summer in Tokyo" -> "Tokyo"
        String cleaned = title.toLowerCase();
        
        if (cleaned.contains(" to ")) {
            String[] parts = title.split("(?i) to ");
            if (parts.length > 1) {
                return parts[1].trim();
            }
        }
        
        if (cleaned.contains(" in ")) {
            String[] parts = title.split("(?i) in ");
            if (parts.length > 1) {
                return parts[1].trim();
            }
        }
        
        // Fallback: use the first word that might be a place name
        String[] words = title.split("\\s+");
        for (String word : words) {
            if (word.length() > 2 && Character.isUpperCase(word.charAt(0))) {
                return word;
            }
        }
        
        // Last fallback: use the title itself
        return title;
    }
    
    public void updateEntityFromRequest(Trip entity, UpdateTripRequest request) {
        if (entity == null || request == null) {
            return;
        }
        
        if (request.getTitle() != null) {
            entity.setTitle(request.getTitle());
        }
        if (request.getStartDate() != null) {
            entity.setStartDate(request.getStartDate());
        }
        if (request.getEndDate() != null) {
            entity.setEndDate(request.getEndDate());
        }
        if (request.getNotes() != null) {
            entity.setNotes(request.getNotes());
        }
    }
}