package com.tripstory.model;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import java.time.LocalDate;
import org.springframework.format.annotation.DateTimeFormat;
import org.openapitools.jackson.nullable.JsonNullable;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import io.swagger.v3.oas.annotations.media.Schema;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * UpdateTripRequest
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2025-08-07T23:30:36.080760+01:00[Europe/Dublin]")
public class UpdateTripRequest {

  private String title;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
  private LocalDate startDate;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
  private LocalDate endDate;

  private String notes;

  public UpdateTripRequest title(String title) {
    this.title = title;
    return this;
  }

  /**
   * Title of the trip
   * @return title
  */
  @Size(max = 255) 
  @Schema(name = "title", example = "Updated Summer Vacation in Paris", description = "Title of the trip", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("title")
  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public UpdateTripRequest startDate(LocalDate startDate) {
    this.startDate = startDate;
    return this;
  }

  /**
   * Start date of the trip
   * @return startDate
  */
  @Valid 
  @Schema(name = "startDate", example = "Mon Aug 12 01:00:00 IST 2024", description = "Start date of the trip", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("startDate")
  public LocalDate getStartDate() {
    return startDate;
  }

  public void setStartDate(LocalDate startDate) {
    this.startDate = startDate;
  }

  public UpdateTripRequest endDate(LocalDate endDate) {
    this.endDate = endDate;
    return this;
  }

  /**
   * End date of the trip
   * @return endDate
  */
  @Valid 
  @Schema(name = "endDate", example = "Thu Aug 15 01:00:00 IST 2024", description = "End date of the trip", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("endDate")
  public LocalDate getEndDate() {
    return endDate;
  }

  public void setEndDate(LocalDate endDate) {
    this.endDate = endDate;
  }

  public UpdateTripRequest notes(String notes) {
    this.notes = notes;
    return this;
  }

  /**
   * Additional notes about the trip
   * @return notes
  */
  @Size(max = 1000) 
  @Schema(name = "notes", example = "Updated notes about the trip", description = "Additional notes about the trip", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("notes")
  public String getNotes() {
    return notes;
  }

  public void setNotes(String notes) {
    this.notes = notes;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    UpdateTripRequest updateTripRequest = (UpdateTripRequest) o;
    return Objects.equals(this.title, updateTripRequest.title) &&
        Objects.equals(this.startDate, updateTripRequest.startDate) &&
        Objects.equals(this.endDate, updateTripRequest.endDate) &&
        Objects.equals(this.notes, updateTripRequest.notes);
  }

  @Override
  public int hashCode() {
    return Objects.hash(title, startDate, endDate, notes);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class UpdateTripRequest {\n");
    sb.append("    title: ").append(toIndentedString(title)).append("\n");
    sb.append("    startDate: ").append(toIndentedString(startDate)).append("\n");
    sb.append("    endDate: ").append(toIndentedString(endDate)).append("\n");
    sb.append("    notes: ").append(toIndentedString(notes)).append("\n");
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

