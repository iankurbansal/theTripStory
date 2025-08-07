package com.tripstory.util;

import com.tripstory.entity.Trip;
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
        
        return entity;
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