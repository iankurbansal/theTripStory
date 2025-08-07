package com.tripstory.service;

import com.tripstory.entity.Trip;
import com.tripstory.exception.TripNotFoundException;
import com.tripstory.repository.TripRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Service class for managing Trip business logic
 * 
 * This service provides business logic for CRUD operations on trips,
 * including validation, error handling, and transaction management.
 */
@Service
@Transactional
public class TripService {

    private static final Logger logger = LoggerFactory.getLogger(TripService.class);

    private final TripRepository tripRepository;
    private final UnsplashService unsplashService;

    @Autowired
    public TripService(TripRepository tripRepository, UnsplashService unsplashService) {
        this.tripRepository = tripRepository;
        this.unsplashService = unsplashService;
    }

    /**
     * Retrieve all trips ordered by start date (most recent first)
     */
    @Transactional(readOnly = true)
    public List<Trip> getAllTrips() {
        logger.debug("Fetching all trips");
        List<Trip> trips = tripRepository.findAllOrderByStartDateDesc();
        logger.info("Found {} trips", trips.size());
        return trips;
    }

    /**
     * Retrieve a trip by its ID
     * 
     * @param id The trip ID
     * @return The trip if found
     * @throws TripNotFoundException if trip is not found
     */
    @Transactional(readOnly = true)
    public Trip getTripById(Long id) {
        logger.debug("Fetching trip with ID: {}", id);
        
        return tripRepository.findById(id)
                .orElseThrow(() -> {
                    logger.warn("Trip not found with ID: {}", id);
                    return new TripNotFoundException("Trip not found with ID: " + id);
                });
    }

    /**
     * Create a new trip
     * 
     * @param trip The trip to create
     * @return The created trip with generated ID
     * @throws IllegalArgumentException if trip data is invalid
     */
    public Trip createTrip(Trip trip) {
        logger.debug("Creating new trip: {}", trip.getTitle());
        
        validateTrip(trip);
        
        // Check for duplicate title
        if (trip.getTitle() != null && tripRepository.existsByTitleIgnoreCase(trip.getTitle())) {
            logger.warn("Trip with title '{}' already exists", trip.getTitle());
            throw new IllegalArgumentException("Trip with title '" + trip.getTitle() + "' already exists");
        }
        
        // Fetch image from Unsplash if destinations exist
        if (!trip.getDestinations().isEmpty()) {
            String firstDestination = trip.getDestinations().get(0).getName();
            UnsplashService.UnsplashPhoto photo = unsplashService.fetchPhotoForDestination(firstDestination);
            
            if (photo != null && photo.urls != null && photo.user != null) {
                trip.setImageUrl(photo.urls.regular);
                trip.setImageAttribution("Photo by " + photo.user.name + " on Unsplash");
                logger.info("Added Unsplash image for trip: {}", trip.getTitle());
            }
        }
        
        Trip savedTrip = tripRepository.save(trip);
        logger.info("Successfully created trip with ID: {}", savedTrip.getId());
        return savedTrip;
    }

    /**
     * Update an existing trip
     * 
     * @param id The ID of the trip to update
     * @param updatedTrip The updated trip data
     * @return The updated trip
     * @throws TripNotFoundException if trip is not found
     */
    public Trip updateTrip(Long id, Trip updatedTrip) {
        logger.debug("Updating trip with ID: {}", id);
        
        Trip existingTrip = getTripById(id);
        
        // Validate updated data
        if (updatedTrip.getTitle() != null || updatedTrip.getStartDate() != null || 
            updatedTrip.getEndDate() != null) {
            validateTripUpdate(updatedTrip, existingTrip);
        }
        
        // Check for duplicate title (excluding current trip)
        if (updatedTrip.getTitle() != null && 
            !updatedTrip.getTitle().equalsIgnoreCase(existingTrip.getTitle()) &&
            tripRepository.existsByTitleIgnoreCase(updatedTrip.getTitle())) {
            logger.warn("Trip with title '{}' already exists", updatedTrip.getTitle());
            throw new IllegalArgumentException("Trip with title '" + updatedTrip.getTitle() + "' already exists");
        }
        
        existingTrip.updateFrom(updatedTrip);
        Trip savedTrip = tripRepository.save(existingTrip);
        logger.info("Successfully updated trip with ID: {}", savedTrip.getId());
        return savedTrip;
    }

    /**
     * Delete a trip by its ID
     * 
     * @param id The ID of the trip to delete
     * @throws TripNotFoundException if trip is not found
     */
    public void deleteTrip(Long id) {
        logger.debug("Deleting trip with ID: {}", id);
        
        Trip trip = getTripById(id); // This will throw exception if not found
        tripRepository.delete(trip);
        logger.info("Successfully deleted trip with ID: {}", id);
    }

    /**
     * Search trips by title
     */
    @Transactional(readOnly = true)
    public List<Trip> searchTripsByTitle(String searchTerm) {
        logger.debug("Searching trips by title: {}", searchTerm);
        return tripRepository.findByTitleContainingIgnoreCase(searchTerm);
    }

    /**
     * Get upcoming trips
     */
    @Transactional(readOnly = true)
    public List<Trip> getUpcomingTrips() {
        logger.debug("Fetching upcoming trips");
        return tripRepository.findUpcomingTrips();
    }

    /**
     * Get past trips
     */
    @Transactional(readOnly = true)
    public List<Trip> getPastTrips() {
        logger.debug("Fetching past trips");
        return tripRepository.findPastTrips();
    }

    /**
     * Get ongoing trips
     */
    @Transactional(readOnly = true)
    public List<Trip> getOngoingTrips() {
        logger.debug("Fetching ongoing trips");
        return tripRepository.findOngoingTrips();
    }

    /**
     * Get trip statistics
     */
    @Transactional(readOnly = true)
    public TripStatistics getTripStatistics() {
        logger.debug("Calculating trip statistics");
        
        long total = tripRepository.count();
        long upcoming = tripRepository.countUpcomingTrips();
        long ongoing = tripRepository.countOngoingTrips();
        long past = tripRepository.countPastTrips();
        
        return new TripStatistics(total, upcoming, ongoing, past);
    }

    /**
     * Validate trip data
     */
    private void validateTrip(Trip trip) {
        if (trip == null) {
            throw new IllegalArgumentException("Trip cannot be null");
        }
        
        if (trip.getTitle() == null || trip.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Trip title is required");
        }
        
        if (trip.getStartDate() == null) {
            throw new IllegalArgumentException("Trip start date is required");
        }
        
        if (trip.getEndDate() == null) {
            throw new IllegalArgumentException("Trip end date is required");
        }
        
        if (trip.getEndDate().isBefore(trip.getStartDate())) {
            throw new IllegalArgumentException("Trip end date cannot be before start date");
        }
        
        // Business rule: trips cannot be longer than 1 year
        if (trip.getStartDate().plusYears(1).isBefore(trip.getEndDate())) {
            throw new IllegalArgumentException("Trip duration cannot exceed 1 year");
        }
    }

    /**
     * Validate trip update data
     */
    private void validateTripUpdate(Trip updatedTrip, Trip existingTrip) {
        LocalDate startDate = updatedTrip.getStartDate() != null ? 
            updatedTrip.getStartDate() : existingTrip.getStartDate();
        LocalDate endDate = updatedTrip.getEndDate() != null ? 
            updatedTrip.getEndDate() : existingTrip.getEndDate();
        
        if (endDate.isBefore(startDate)) {
            throw new IllegalArgumentException("Trip end date cannot be before start date");
        }
        
        if (startDate.plusYears(1).isBefore(endDate)) {
            throw new IllegalArgumentException("Trip duration cannot exceed 1 year");
        }
    }

    /**
     * Inner class for trip statistics
     */
    public static class TripStatistics {
        private final long total;
        private final long upcoming;
        private final long ongoing;
        private final long past;

        public TripStatistics(long total, long upcoming, long ongoing, long past) {
            this.total = total;
            this.upcoming = upcoming;
            this.ongoing = ongoing;
            this.past = past;
        }

        public long getTotal() { return total; }
        public long getUpcoming() { return upcoming; }
        public long getOngoing() { return ongoing; }
        public long getPast() { return past; }
    }
}