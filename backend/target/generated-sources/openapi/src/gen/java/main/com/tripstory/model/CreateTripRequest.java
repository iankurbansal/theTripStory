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
 * CreateTripRequest
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2025-08-06T00:09:12.897247+01:00[Europe/Dublin]")
public class CreateTripRequest {

  private String title;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
  private LocalDate startDate;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
  private LocalDate endDate;

  private String notes;

  public CreateTripRequest() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public CreateTripRequest(String title, LocalDate startDate, LocalDate endDate) {
    this.title = title;
    this.startDate = startDate;
    this.endDate = endDate;
  }

  public CreateTripRequest title(String title) {
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

  public CreateTripRequest startDate(LocalDate startDate) {
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

  public CreateTripRequest endDate(LocalDate endDate) {
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

  public CreateTripRequest notes(String notes) {
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

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    CreateTripRequest createTripRequest = (CreateTripRequest) o;
    return Objects.equals(this.title, createTripRequest.title) &&
        Objects.equals(this.startDate, createTripRequest.startDate) &&
        Objects.equals(this.endDate, createTripRequest.endDate) &&
        Objects.equals(this.notes, createTripRequest.notes);
  }

  @Override
  public int hashCode() {
    return Objects.hash(title, startDate, endDate, notes);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class CreateTripRequest {\n");
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

