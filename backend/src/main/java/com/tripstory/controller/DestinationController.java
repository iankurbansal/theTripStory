package com.tripstory.controller;

import com.tripstory.entity.Destination;
import com.tripstory.entity.Trip;
import com.tripstory.service.DestinationService;
import com.tripstory.service.MapboxService;
import com.tripstory.service.TripService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST Controller for managing destinations within trips
 * 
 * Provides endpoints for destination CRUD operations and Mapbox integration
 */
@RestController
@RequestMapping("/api/trips/{tripId}/destinations")
@CrossOrigin(origins = {"http://localhost:3000", "https://thetripstory.com"})
public class DestinationController {

    @Autowired
    private DestinationService destinationService;

    @Autowired
    private TripService tripService;

    @Autowired
    private MapboxService mapboxService;

    /**
     * Get all destinations for a specific trip
     */
    @GetMapping
    public ResponseEntity<List<Destination>> getDestinations(@PathVariable Long tripId) {
        Trip trip = tripService.getTripById(tripId);
        if (trip == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(trip.getDestinations());
    }

    /**
     * Add a new destination to a trip
     */
    @PostMapping
    public ResponseEntity<Destination> addDestination(
            @PathVariable Long tripId, 
            @Valid @RequestBody Destination destination) {
        
        Trip trip = tripService.getTripById(tripId);
        if (trip == null) {
            return ResponseEntity.notFound().build();
        }

        destination.setTrip(trip);
        Destination savedDestination = destinationService.saveDestination(destination);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedDestination);
    }

    /**
     * Update an existing destination
     */
    @PutMapping("/{destinationId}")
    public ResponseEntity<Destination> updateDestination(
            @PathVariable Long tripId,
            @PathVariable Long destinationId,
            @Valid @RequestBody Destination destinationUpdate) {
        
        Destination existingDestination = destinationService.getDestinationById(destinationId);
        if (existingDestination == null || !existingDestination.getTrip().getId().equals(tripId)) {
            return ResponseEntity.notFound().build();
        }

        existingDestination.updateFrom(destinationUpdate);
        Destination savedDestination = destinationService.saveDestination(existingDestination);
        return ResponseEntity.ok(savedDestination);
    }

    /**
     * Delete a destination from a trip
     */
    @DeleteMapping("/{destinationId}")
    public ResponseEntity<Void> deleteDestination(
            @PathVariable Long tripId,
            @PathVariable Long destinationId) {
        
        Destination destination = destinationService.getDestinationById(destinationId);
        if (destination == null || !destination.getTrip().getId().equals(tripId)) {
            return ResponseEntity.notFound().build();
        }

        destinationService.deleteDestination(destinationId);
        return ResponseEntity.noContent().build();
    }

    /**
     * Reorder destinations within a trip
     */
    @PutMapping("/reorder")
    public ResponseEntity<List<Destination>> reorderDestinations(
            @PathVariable Long tripId,
            @RequestBody List<Long> destinationIds) {
        
        Trip trip = tripService.getTripById(tripId);
        if (trip == null) {
            return ResponseEntity.notFound().build();
        }

        List<Destination> reorderedDestinations = destinationService.reorderDestinations(tripId, destinationIds);
        return ResponseEntity.ok(reorderedDestinations);
    }
}

/**
 * REST Controller for Mapbox destination search
 */
@RestController
@RequestMapping("/api/destinations")
@CrossOrigin(origins = {"http://localhost:3000", "https://thetripstory.com"})
class MapboxDestinationController {

    @Autowired
    private MapboxService mapboxService;

    /**
     * Search for destinations using Mapbox Geocoding API
     */
    @GetMapping("/search")
    public ResponseEntity<List<MapboxService.DestinationSuggestion>> searchDestinations(
            @RequestParam String query,
            @RequestParam(defaultValue = "5") Integer limit) {
        
        if (query == null || query.trim().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        List<MapboxService.DestinationSuggestion> suggestions = 
                mapboxService.searchDestinations(query, limit);
        
        return ResponseEntity.ok(suggestions);
    }
}