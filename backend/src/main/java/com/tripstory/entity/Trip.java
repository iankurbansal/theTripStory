package com.tripstory.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * Trip entity representing a travel trip in the system
 * 
 * This entity stores basic trip information including title, dates, and notes.
 * It uses JPA auditing to automatically track creation and modification timestamps.
 */
@Entity
@Table(name = "trips")
@EntityListeners(AuditingEntityListener.class)
public class Trip {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Trip title is required")
    @Size(max = 255, message = "Trip title must not exceed 255 characters")
    @Column(nullable = false)
    private String title;

    @NotNull(message = "Start date is required")
    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @NotNull(message = "End date is required")
    @Column(name = "end_date", nullable = false)
    private LocalDate endDate;

    @Size(max = 1000, message = "Notes must not exceed 1000 characters")
    @Column(length = 1000)
    private String notes;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(name = "image_attribution", length = 255)
    private String imageAttribution;

    @OneToMany(mappedBy = "trip", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    @OrderBy("orderIndex ASC")
    private List<Destination> destinations = new ArrayList<>();

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    // Default constructor
    public Trip() {}

    // Constructor for creating new trips
    public Trip(String title, LocalDate startDate, LocalDate endDate, String notes) {
        this.title = title;
        this.startDate = startDate;
        this.endDate = endDate;
        this.notes = notes;
        this.destinations = new ArrayList<>();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getImageAttribution() {
        return imageAttribution;
    }

    public void setImageAttribution(String imageAttribution) {
        this.imageAttribution = imageAttribution;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<Destination> getDestinations() {
        return destinations;
    }

    public void setDestinations(List<Destination> destinations) {
        this.destinations = destinations;
        // Ensure bidirectional relationship
        if (destinations != null) {
            for (Destination destination : destinations) {
                destination.setTrip(this);
            }
        }
    }

    // Business logic methods
    
    /**
     * Validates that the end date is not before the start date
     */
    @PrePersist
    @PreUpdate
    private void validateDates() {
        if (startDate != null && endDate != null && endDate.isBefore(startDate)) {
            throw new IllegalArgumentException("End date cannot be before start date");
        }
    }

    /**
     * Updates trip details while preserving the ID and audit timestamps
     */
    public void updateFrom(Trip other) {
        if (other.getTitle() != null) {
            this.title = other.getTitle();
        }
        if (other.getStartDate() != null) {
            this.startDate = other.getStartDate();
        }
        if (other.getEndDate() != null) {
            this.endDate = other.getEndDate();
        }
        if (other.getNotes() != null) {
            this.notes = other.getNotes();
        }
        if (other.getImageUrl() != null) {
            this.imageUrl = other.getImageUrl();
        }
        if (other.getImageAttribution() != null) {
            this.imageAttribution = other.getImageAttribution();
        }
    }

    /**
     * Helper methods for managing destinations
     */
    public void addDestination(Destination destination) {
        destinations.add(destination);
        destination.setTrip(this);
        // Set order index if not already set
        if (destination.getOrderIndex() == null) {
            destination.setOrderIndex(destinations.size() - 1);
        }
    }

    public void removeDestination(Destination destination) {
        destinations.remove(destination);
        destination.setTrip(null);
    }

    public void clearDestinations() {
        for (Destination destination : destinations) {
            destination.setTrip(null);
        }
        destinations.clear();
    }

    /**
     * Get a summary of destinations for display purposes
     */
    public String getDestinationSummary() {
        if (destinations.isEmpty()) {
            return "No destinations";
        }
        if (destinations.size() == 1) {
            return destinations.get(0).getName();
        }
        if (destinations.size() <= 3) {
            return destinations.stream()
                    .map(Destination::getName)
                    .reduce((a, b) -> a + ", " + b)
                    .orElse("No destinations");
        }
        return destinations.get(0).getName() + " + " + (destinations.size() - 1) + " more";
    }

    // equals and hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Trip trip = (Trip) o;
        return Objects.equals(id, trip.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    // toString
    @Override
    public String toString() {
        return "Trip{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", notes='" + notes + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}