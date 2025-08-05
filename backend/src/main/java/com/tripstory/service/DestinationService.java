package com.tripstory.service;

import com.tripstory.entity.Destination;
import com.tripstory.repository.DestinationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service layer for managing destinations
 * 
 * Handles business logic for destination operations including ordering and validation
 */
@Service
@Transactional
public class DestinationService {

    @Autowired
    private DestinationRepository destinationRepository;

    /**
     * Get destination by ID
     */
    public Destination getDestinationById(Long id) {
        Optional<Destination> destination = destinationRepository.findById(id);
        return destination.orElse(null);
    }

    /**
     * Get all destinations for a trip, ordered by orderIndex
     */
    public List<Destination> getDestinationsByTripId(Long tripId) {
        return destinationRepository.findByTripIdOrderByOrderIndexAsc(tripId);
    }

    /**
     * Save a destination
     */
    public Destination saveDestination(Destination destination) {
        // If no order index is set, set it to the next available position
        if (destination.getOrderIndex() == null && destination.getTrip() != null) {
            int maxIndex = destinationRepository.findMaxOrderIndexByTripId(destination.getTrip().getId());
            destination.setOrderIndex(maxIndex + 1);
        }
        
        return destinationRepository.save(destination);
    }

    /**
     * Delete a destination
     */
    public void deleteDestination(Long id) {
        destinationRepository.deleteById(id);
    }

    /**
     * Reorder destinations within a trip
     */
    @Transactional
    public List<Destination> reorderDestinations(Long tripId, List<Long> destinationIds) {
        // Validate that all destinations belong to the trip
        List<Destination> destinations = destinationRepository.findByTripIdOrderByOrderIndexAsc(tripId);
        
        if (destinations.size() != destinationIds.size()) {
            throw new IllegalArgumentException("Destination count mismatch");
        }

        // Update order indices
        for (int i = 0; i < destinationIds.size(); i++) {
            Long destinationId = destinationIds.get(i);
            Destination destination = destinations.stream()
                    .filter(d -> d.getId().equals(destinationId))
                    .findFirst()
                    .orElseThrow(() -> new IllegalArgumentException("Destination not found: " + destinationId));
            
            destination.setOrderIndex(i);
            destinationRepository.save(destination);
        }

        return destinationRepository.findByTripIdOrderByOrderIndexAsc(tripId);
    }

    /**
     * Create destination from Mapbox suggestion
     */
    public Destination createDestinationFromSuggestion(MapboxService.DestinationSuggestion suggestion) {
        Destination destination = new Destination();
        destination.setName(suggestion.getName());
        destination.setFullName(suggestion.getFullName());
        destination.setType(suggestion.getType());
        destination.setLatitude(suggestion.getLatitude());
        destination.setLongitude(suggestion.getLongitude());
        return destination;
    }

    /**
     * Bulk create destinations from Mapbox suggestions
     */
    @Transactional
    public List<Destination> createDestinationsFromSuggestions(
            Long tripId, 
            List<MapboxService.DestinationSuggestion> suggestions) {
        
        List<Destination> destinations = suggestions.stream()
                .map(this::createDestinationFromSuggestion)
                .toList();

        // Set trip and order indices
        int startIndex = destinationRepository.findMaxOrderIndexByTripId(tripId) + 1;
        for (int i = 0; i < destinations.size(); i++) {
            Destination destination = destinations.get(i);
            destination.setOrderIndex(startIndex + i);
            // Trip will be set by the controller
        }

        return destinations.stream()
                .map(destinationRepository::save)
                .toList();
    }
}