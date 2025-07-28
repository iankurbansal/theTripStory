package com.tripstory.repository;

import com.tripstory.entity.Trip;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Trip entity
 * 
 * Provides CRUD operations and custom query methods for managing trips in the database.
 * Uses Spring Data JPA for automatic implementation generation.
 */
@Repository
public interface TripRepository extends JpaRepository<Trip, Long> {

    /**
     * Find all trips ordered by start date descending (most recent first)
     */
    @Query("SELECT t FROM Trip t ORDER BY t.startDate DESC")
    List<Trip> findAllOrderByStartDateDesc();

    /**
     * Find trips by title containing the search term (case-insensitive)
     */
    @Query("SELECT t FROM Trip t WHERE LOWER(t.title) LIKE LOWER(CONCAT('%', :searchTerm, '%'))")
    List<Trip> findByTitleContainingIgnoreCase(@Param("searchTerm") String searchTerm);

    /**
     * Find trips that start within a date range
     */
    @Query("SELECT t FROM Trip t WHERE t.startDate BETWEEN :startDate AND :endDate")
    List<Trip> findTripsStartingBetween(@Param("startDate") LocalDate startDate, 
                                      @Param("endDate") LocalDate endDate);

    /**
     * Find upcoming trips (start date is in the future)
     */
    @Query("SELECT t FROM Trip t WHERE t.startDate > CURRENT_DATE ORDER BY t.startDate ASC")
    List<Trip> findUpcomingTrips();

    /**
     * Find past trips (end date is in the past)
     */
    @Query("SELECT t FROM Trip t WHERE t.endDate < CURRENT_DATE ORDER BY t.startDate DESC")
    List<Trip> findPastTrips();

    /**
     * Find current/ongoing trips (current date is between start and end date)
     */
    @Query("SELECT t FROM Trip t WHERE CURRENT_DATE BETWEEN t.startDate AND t.endDate")
    List<Trip> findOngoingTrips();

    /**
     * Check if a trip exists with the given title (case-insensitive)
     */
    @Query("SELECT CASE WHEN COUNT(t) > 0 THEN true ELSE false END FROM Trip t WHERE LOWER(t.title) = LOWER(:title)")
    boolean existsByTitleIgnoreCase(@Param("title") String title);

    /**
     * Find the most recently created trip
     */
    Optional<Trip> findTopByOrderByCreatedAtDesc();

    /**
     * Count trips by status (upcoming, ongoing, past)
     */
    @Query("SELECT COUNT(t) FROM Trip t WHERE t.startDate > CURRENT_DATE")
    long countUpcomingTrips();

    @Query("SELECT COUNT(t) FROM Trip t WHERE CURRENT_DATE BETWEEN t.startDate AND t.endDate")
    long countOngoingTrips();

    @Query("SELECT COUNT(t) FROM Trip t WHERE t.endDate < CURRENT_DATE")
    long countPastTrips();
}