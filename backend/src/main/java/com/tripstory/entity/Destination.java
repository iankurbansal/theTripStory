package com.tripstory.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Destination entity representing a travel destination within a trip
 * 
 * Each destination belongs to a trip and contains location information
 * including coordinates from Mapbox integration
 */
@Entity
@Table(name = "destinations")
@EntityListeners(AuditingEntityListener.class)
public class Destination {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Destination name is required")
    @Size(max = 255, message = "Destination name must not exceed 255 characters")
    @Column(nullable = false)
    private String name;

    @Size(max = 500, message = "Full name must not exceed 500 characters")
    @Column(name = "full_name")
    private String fullName;

    @Size(max = 50, message = "Type must not exceed 50 characters")
    @Column
    private String type;

    @Column
    private Double latitude;

    @Column
    private Double longitude;

    @Size(max = 1000, message = "Description must not exceed 1000 characters")
    @Column(length = 1000)
    private String description;

    @Column(name = "order_index")
    private Integer orderIndex;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_id", nullable = false)
    private Trip trip;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    // Default constructor
    public Destination() {}

    // Constructor for creating new destinations
    public Destination(String name, String fullName, String type, Double latitude, Double longitude) {
        this.name = name;
        this.fullName = fullName;
        this.type = type;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    // Constructor with trip
    public Destination(String name, String fullName, String type, Double latitude, Double longitude, Trip trip) {
        this.name = name;
        this.fullName = fullName;
        this.type = type;
        this.latitude = latitude;
        this.longitude = longitude;
        this.trip = trip;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
    }

    public Trip getTrip() {
        return trip;
    }

    public void setTrip(Trip trip) {
        this.trip = trip;
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

    // Business logic methods
    
    /**
     * Updates destination details while preserving the ID and audit timestamps
     */
    public void updateFrom(Destination other) {
        if (other.getName() != null) {
            this.name = other.getName();
        }
        if (other.getFullName() != null) {
            this.fullName = other.getFullName();
        }
        if (other.getType() != null) {
            this.type = other.getType();
        }
        if (other.getLatitude() != null) {
            this.latitude = other.getLatitude();
        }
        if (other.getLongitude() != null) {
            this.longitude = other.getLongitude();
        }
        if (other.getDescription() != null) {
            this.description = other.getDescription();
        }
        if (other.getOrderIndex() != null) {
            this.orderIndex = other.getOrderIndex();
        }
    }

    // equals and hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Destination that = (Destination) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    // toString
    @Override
    public String toString() {
        return "Destination{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", fullName='" + fullName + '\'' +
                ", type='" + type + '\'' +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", orderIndex=" + orderIndex +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}