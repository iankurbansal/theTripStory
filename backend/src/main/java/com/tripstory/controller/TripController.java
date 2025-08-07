package com.tripstory.controller;

import com.tripstory.model.CreateTripRequest;
import com.tripstory.model.UpdateTripRequest;
import com.tripstory.service.TripService;
import com.tripstory.util.TripConverter;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

/**
 * REST Controller for Trip management
 * 
 * Provides HTTP endpoints for CRUD operations on trips.
 * Implements the OpenAPI specification defined in api-spec.yaml.
 */
@RestController
@RequestMapping("/api/trips")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:80", "http://frontend", "http://frontend:80", "https://thetripstory.com"})
@Tag(name = "Trips", description = "Trip management operations")
public class TripController {

    private static final Logger logger = LoggerFactory.getLogger(TripController.class);

    private final TripService tripService;
    private final TripConverter tripConverter;

    @Autowired
    public TripController(TripService tripService, TripConverter tripConverter) {
        this.tripService = tripService;
        this.tripConverter = tripConverter;
    }

    @Operation(summary = "Get all trips", description = "Retrieve a list of all trips")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully retrieved trips",
                content = @Content(mediaType = "application/json", 
                schema = @Schema(implementation = com.tripstory.model.Trip.class))),
        @ApiResponse(responseCode = "500", description = "Internal server error")
    })
    @GetMapping
    public ResponseEntity<List<com.tripstory.model.Trip>> getAllTrips() {
        logger.info("GET /api/trips - Fetching all trips");
        
        List<com.tripstory.entity.Trip> tripEntities = tripService.getAllTrips();
        List<com.tripstory.model.Trip> trips = tripEntities.stream()
            .map(tripConverter::toModel)
            .collect(Collectors.toList());
        logger.info("Successfully retrieved {} trips", trips.size());
        
        return ResponseEntity.ok(trips);
    }

    @Operation(summary = "Get trip by ID", description = "Retrieve a specific trip by its ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Trip found",
                content = @Content(mediaType = "application/json", 
                schema = @Schema(implementation = com.tripstory.model.Trip.class))),
        @ApiResponse(responseCode = "404", description = "Trip not found"),
        @ApiResponse(responseCode = "500", description = "Internal server error")
    })
    @GetMapping("/{tripId}")
    public ResponseEntity<com.tripstory.model.Trip> getTripById(
            @Parameter(description = "ID of the trip to retrieve", required = true)
            @PathVariable Long tripId) {
        
        logger.info("GET /api/trips/{} - Fetching trip by ID", tripId);
        
        com.tripstory.entity.Trip tripEntity = tripService.getTripById(tripId);
        com.tripstory.model.Trip trip = tripConverter.toModel(tripEntity);
        logger.info("Successfully retrieved trip: {}", trip.getTitle());
        
        return ResponseEntity.ok(trip);
    }

    @Operation(summary = "Create a new trip", description = "Create a new trip with the provided details")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Trip created successfully",
                content = @Content(mediaType = "application/json", 
                schema = @Schema(implementation = com.tripstory.model.Trip.class))),
        @ApiResponse(responseCode = "400", description = "Bad request - invalid input"),
        @ApiResponse(responseCode = "500", description = "Internal server error")
    })
    @PostMapping
    public ResponseEntity<com.tripstory.model.Trip> createTrip(
            @Parameter(description = "Trip data to create", required = true)
            @Valid @RequestBody CreateTripRequest createRequest) {
        
        logger.info("POST /api/trips - Creating new trip: {}", createRequest.getTitle());
        
        com.tripstory.entity.Trip tripEntity = tripConverter.fromCreateRequest(createRequest);
        com.tripstory.entity.Trip createdEntity = tripService.createTrip(tripEntity);
        com.tripstory.model.Trip createdTrip = tripConverter.toModel(createdEntity);
        logger.info("Successfully created trip with ID: {}", createdTrip.getId());
        
        return new ResponseEntity<>(createdTrip, HttpStatus.CREATED);
    }

    @Operation(summary = "Update trip", description = "Update an existing trip with new details")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Trip updated successfully",
                content = @Content(mediaType = "application/json", 
                schema = @Schema(implementation = com.tripstory.model.Trip.class))),
        @ApiResponse(responseCode = "400", description = "Bad request - invalid input"),
        @ApiResponse(responseCode = "404", description = "Trip not found"),
        @ApiResponse(responseCode = "500", description = "Internal server error")
    })
    @PutMapping("/{tripId}")
    public ResponseEntity<com.tripstory.model.Trip> updateTrip(
            @Parameter(description = "ID of the trip to update", required = true)
            @PathVariable Long tripId,
            @Parameter(description = "Updated trip data", required = true)
            @Valid @RequestBody UpdateTripRequest updateRequest) {
        
        logger.info("PUT /api/trips/{} - Updating trip", tripId);
        
        com.tripstory.entity.Trip existingEntity = tripService.getTripById(tripId);
        tripConverter.updateEntityFromRequest(existingEntity, updateRequest);
        com.tripstory.entity.Trip updatedEntity = tripService.updateTrip(tripId, existingEntity);
        com.tripstory.model.Trip updatedTrip = tripConverter.toModel(updatedEntity);
        logger.info("Successfully updated trip: {}", updatedTrip.getTitle());
        
        return ResponseEntity.ok(updatedTrip);
    }

    @Operation(summary = "Delete trip", description = "Delete a trip by its ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "Trip deleted successfully"),
        @ApiResponse(responseCode = "404", description = "Trip not found"),
        @ApiResponse(responseCode = "500", description = "Internal server error")
    })
    @DeleteMapping("/{tripId}")
    public ResponseEntity<Void> deleteTrip(
            @Parameter(description = "ID of the trip to delete", required = true)
            @PathVariable Long tripId) {
        
        logger.info("DELETE /api/trips/{} - Deleting trip", tripId);
        
        tripService.deleteTrip(tripId);
        logger.info("Successfully deleted trip with ID: {}", tripId);
        
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Search trips", description = "Search trips by title")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Search completed successfully",
                content = @Content(mediaType = "application/json", 
                schema = @Schema(implementation = com.tripstory.model.Trip.class))),
        @ApiResponse(responseCode = "500", description = "Internal server error")
    })
    @GetMapping("/search")
    public ResponseEntity<List<com.tripstory.model.Trip>> searchTrips(
            @Parameter(description = "Search term for trip title")
            @RequestParam String q) {
        
        logger.info("GET /api/trips/search?q={} - Searching trips", q);
        
        List<com.tripstory.entity.Trip> tripEntities = tripService.searchTripsByTitle(q);
        List<com.tripstory.model.Trip> trips = tripEntities.stream()
            .map(tripConverter::toModel)
            .collect(Collectors.toList());
        logger.info("Found {} trips matching search term: {}", trips.size(), q);
        
        return ResponseEntity.ok(trips);
    }

    @Operation(summary = "Get upcoming trips", description = "Retrieve all upcoming trips")
    @GetMapping("/upcoming")
    public ResponseEntity<List<com.tripstory.model.Trip>> getUpcomingTrips() {
        logger.info("GET /api/trips/upcoming - Fetching upcoming trips");
        
        List<com.tripstory.entity.Trip> tripEntities = tripService.getUpcomingTrips();
        List<com.tripstory.model.Trip> trips = tripEntities.stream()
            .map(tripConverter::toModel)
            .collect(Collectors.toList());
        logger.info("Found {} upcoming trips", trips.size());
        
        return ResponseEntity.ok(trips);
    }

    @Operation(summary = "Get past trips", description = "Retrieve all past trips")
    @GetMapping("/past")
    public ResponseEntity<List<com.tripstory.model.Trip>> getPastTrips() {
        logger.info("GET /api/trips/past - Fetching past trips");
        
        List<com.tripstory.entity.Trip> tripEntities = tripService.getPastTrips();
        List<com.tripstory.model.Trip> trips = tripEntities.stream()
            .map(tripConverter::toModel)
            .collect(Collectors.toList());
        logger.info("Found {} past trips", trips.size());
        
        return ResponseEntity.ok(trips);
    }

    @Operation(summary = "Get ongoing trips", description = "Retrieve all ongoing trips")
    @GetMapping("/ongoing")
    public ResponseEntity<List<com.tripstory.model.Trip>> getOngoingTrips() {
        logger.info("GET /api/trips/ongoing - Fetching ongoing trips");
        
        List<com.tripstory.entity.Trip> tripEntities = tripService.getOngoingTrips();
        List<com.tripstory.model.Trip> trips = tripEntities.stream()
            .map(tripConverter::toModel)
            .collect(Collectors.toList());
        logger.info("Found {} ongoing trips", trips.size());
        
        return ResponseEntity.ok(trips);
    }

    @Operation(summary = "Get trip statistics", description = "Get statistics about trips")
    @GetMapping("/statistics")
    public ResponseEntity<TripService.TripStatistics> getTripStatistics() {
        logger.info("GET /api/trips/statistics - Fetching trip statistics");
        
        TripService.TripStatistics stats = tripService.getTripStatistics();
        logger.info("Trip statistics: total={}, upcoming={}, ongoing={}, past={}", 
                   stats.getTotal(), stats.getUpcoming(), stats.getOngoing(), stats.getPast());
        
        return ResponseEntity.ok(stats);
    }

    @Operation(summary = "Test endpoint", description = "Test endpoint without authentication")
    @GetMapping("/test")
    public ResponseEntity<String> testEndpoint() {
        logger.info("GET /api/trips/test - Test endpoint called");
        return ResponseEntity.ok("Backend is working! Authentication is configured.");
    }
}