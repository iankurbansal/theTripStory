package com.tripstory.repository;

import com.tripstory.entity.Destination;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository interface for Destination entity
 * 
 * Provides data access methods for destination management
 */
@Repository
public interface DestinationRepository extends JpaRepository<Destination, Long> {

    /**
     * Find all destinations for a trip, ordered by orderIndex
     */
    List<Destination> findByTripIdOrderByOrderIndexAsc(Long tripId);

    /**
     * Find the maximum order index for a trip's destinations
     */
    @Query("SELECT COALESCE(MAX(d.orderIndex), -1) FROM Destination d WHERE d.trip.id = :tripId")
    int findMaxOrderIndexByTripId(@Param("tripId") Long tripId);

    /**
     * Count destinations for a trip
     */
    long countByTripId(Long tripId);

    /**
     * Delete all destinations for a trip
     */
    void deleteByTripId(Long tripId);
}