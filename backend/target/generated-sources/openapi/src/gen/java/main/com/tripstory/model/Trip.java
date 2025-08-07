package com.tripstory.model;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import org.springframework.format.annotation.DateTimeFormat;
import org.openapitools.jackson.nullable.JsonNullable;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import io.swagger.v3.oas.annotations.media.Schema;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * Trip
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2025-08-07T23:53:25.043508+01:00[Europe/Dublin]")
public class Trip {

  private Long id;

  private String title;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
  private LocalDate startDate;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
  private LocalDate endDate;

  private String notes;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
  private OffsetDateTime createdAt;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
  private OffsetDateTime updatedAt;

  private String imageUrl;

  private String imageAttribution;

  public Trip() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public Trip(Long id, String title, LocalDate startDate, LocalDate endDate) {
    this.id = id;
    this.title = title;
    this.startDate = startDate;
    this.endDate = endDate;
  }

  public Trip id(Long id) {
    this.id = id;
    return this;
  }

  /**
   * Unique identifier for the trip
   * @return id
  */
  @NotNull 
  @Schema(name = "id", example = "1", description = "Unique identifier for the trip", requiredMode = Schema.RequiredMode.REQUIRED)
  @JsonProperty("id")
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Trip title(String title) {
    this.title = title;
    return this;
  }

  /**
   * Title of the trip
   * @return title
  */
  @NotNull @Size(max = 255) 
  @Schema(name = "title", example = "Summer Vacation in Paris", description = "Title of the trip", requiredMode = Schema.RequiredMode.REQUIRED)
  @JsonProperty("title")
  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public Trip startDate(LocalDate startDate) {
    this.startDate = startDate;
    return this;
  }

  /**
   * Start date of the trip
   * @return startDate
  */
  @NotNull @Valid 
  @Schema(name = "startDate", example = "Mon Aug 12 01:00:00 IST 2024", description = "Start date of the trip", requiredMode = Schema.RequiredMode.REQUIRED)
  @JsonProperty("startDate")
  public LocalDate getStartDate() {
    return startDate;
  }

  public void setStartDate(LocalDate startDate) {
    this.startDate = startDate;
  }

  public Trip endDate(LocalDate endDate) {
    this.endDate = endDate;
    return this;
  }

  /**
   * End date of the trip
   * @return endDate
  */
  @NotNull @Valid 
  @Schema(name = "endDate", example = "Thu Aug 15 01:00:00 IST 2024", description = "End date of the trip", requiredMode = Schema.RequiredMode.REQUIRED)
  @JsonProperty("endDate")
  public LocalDate getEndDate() {
    return endDate;
  }

  public void setEndDate(LocalDate endDate) {
    this.endDate = endDate;
  }

  public Trip notes(String notes) {
    this.notes = notes;
    return this;
  }

  /**
   * Additional notes about the trip
   * @return notes
  */
  @Size(max = 1000) 
  @Schema(name = "notes", example = "Don't forget to visit the Eiffel Tower!", description = "Additional notes about the trip", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("notes")
  public String getNotes() {
    return notes;
  }

  public void setNotes(String notes) {
    this.notes = notes;
  }

  public Trip createdAt(OffsetDateTime createdAt) {
    this.createdAt = createdAt;
    return this;
  }

  /**
   * Timestamp when the trip was created
   * @return createdAt
  */
  @Valid 
  @Schema(name = "createdAt", accessMode = Schema.AccessMode.READ_ONLY, example = "2024-01-15T10:30Z", description = "Timestamp when the trip was created", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("createdAt")
  public OffsetDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(OffsetDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public Trip updatedAt(OffsetDateTime updatedAt) {
    this.updatedAt = updatedAt;
    return this;
  }

  /**
   * Timestamp when the trip was last updated
   * @return updatedAt
  */
  @Valid 
  @Schema(name = "updatedAt", accessMode = Schema.AccessMode.READ_ONLY, example = "2024-01-15T10:30Z", description = "Timestamp when the trip was last updated", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("updatedAt")
  public OffsetDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(OffsetDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  public Trip imageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
    return this;
  }

  /**
   * URL of the trip image from Unsplash
   * @return imageUrl
  */
  @Size(max = 500) 
  @Schema(name = "imageUrl", example = "https://images.unsplash.com/photo-1499856871958-5b9627545d1a", description = "URL of the trip image from Unsplash", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("imageUrl")
  public String getImageUrl() {
    return imageUrl;
  }

  public void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  public Trip imageAttribution(String imageAttribution) {
    this.imageAttribution = imageAttribution;
    return this;
  }

  /**
   * Attribution for the image (photographer and source)
   * @return imageAttribution
  */
  @Size(max = 255) 
  @Schema(name = "imageAttribution", example = "Photo by John Doe on Unsplash", description = "Attribution for the image (photographer and source)", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("imageAttribution")
  public String getImageAttribution() {
    return imageAttribution;
  }

  public void setImageAttribution(String imageAttribution) {
    this.imageAttribution = imageAttribution;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    Trip trip = (Trip) o;
    return Objects.equals(this.id, trip.id) &&
        Objects.equals(this.title, trip.title) &&
        Objects.equals(this.startDate, trip.startDate) &&
        Objects.equals(this.endDate, trip.endDate) &&
        Objects.equals(this.notes, trip.notes) &&
        Objects.equals(this.createdAt, trip.createdAt) &&
        Objects.equals(this.updatedAt, trip.updatedAt) &&
        Objects.equals(this.imageUrl, trip.imageUrl) &&
        Objects.equals(this.imageAttribution, trip.imageAttribution);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, title, startDate, endDate, notes, createdAt, updatedAt, imageUrl, imageAttribution);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class Trip {\n");
    sb.append("    id: ").append(toIndentedString(id)).append("\n");
    sb.append("    title: ").append(toIndentedString(title)).append("\n");
    sb.append("    startDate: ").append(toIndentedString(startDate)).append("\n");
    sb.append("    endDate: ").append(toIndentedString(endDate)).append("\n");
    sb.append("    notes: ").append(toIndentedString(notes)).append("\n");
    sb.append("    createdAt: ").append(toIndentedString(createdAt)).append("\n");
    sb.append("    updatedAt: ").append(toIndentedString(updatedAt)).append("\n");
    sb.append("    imageUrl: ").append(toIndentedString(imageUrl)).append("\n");
    sb.append("    imageAttribution: ").append(toIndentedString(imageAttribution)).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(Object o) {
    if (o == null) {
      return "null";
    }
    return o.toString().replace("\n", "\n    ");
  }
}

