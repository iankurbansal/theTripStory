package com.tripstory.exception;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

/**
 * Global exception handler for the TripStory API
 * 
 * Provides centralized exception handling across all controllers,
 * ensuring consistent error response format and proper HTTP status codes.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * Handle TripNotFoundException
     */
    @ExceptionHandler(TripNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleTripNotFoundException(
            TripNotFoundException ex, WebRequest request) {
        
        logger.warn("Trip not found: {}", ex.getMessage());
        
        ErrorResponse errorResponse = new ErrorResponse(
            ex.getMessage(),
            "The requested trip could not be found",
            LocalDateTime.now(),
            request.getDescription(false).replace("uri=", "")
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }

    /**
     * Handle IllegalArgumentException (validation errors)
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArgumentException(
            IllegalArgumentException ex, WebRequest request) {
        
        logger.warn("Validation error: {}", ex.getMessage());
        
        ErrorResponse errorResponse = new ErrorResponse(
            ex.getMessage(),
            "Invalid request data provided",
            LocalDateTime.now(),
            request.getDescription(false).replace("uri=", "")
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }

    /**
     * Handle MethodArgumentNotValidException (Bean validation errors)
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationExceptions(
            MethodArgumentNotValidException ex, WebRequest request) {
        
        logger.warn("Bean validation error: {}", ex.getMessage());
        
        Map<String, String> validationErrors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            validationErrors.put(fieldName, errorMessage);
        });
        
        String message = "Validation failed for fields: " + validationErrors.keySet();
        String details = validationErrors.toString();
        
        ErrorResponse errorResponse = new ErrorResponse(
            message,
            details,
            LocalDateTime.now(),
            request.getDescription(false).replace("uri=", "")
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }

    /**
     * Handle all other exceptions
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGlobalException(
            Exception ex, WebRequest request) {
        
        logger.error("Unexpected error occurred: ", ex);
        
        ErrorResponse errorResponse = new ErrorResponse(
            "An unexpected error occurred",
            "Please try again later or contact support if the problem persists",
            LocalDateTime.now(),
            request.getDescription(false).replace("uri=", "")
        );
        
        return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    /**
     * Error response DTO
     */
    public static class ErrorResponse {
        private String message;
        private String details;
        private LocalDateTime timestamp;
        private String path;

        public ErrorResponse() {}

        public ErrorResponse(String message, String details, LocalDateTime timestamp, String path) {
            this.message = message;
            this.details = details;
            this.timestamp = timestamp;
            this.path = path;
        }

        // Getters and setters
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }

        public String getDetails() { return details; }
        public void setDetails(String details) { this.details = details; }

        public LocalDateTime getTimestamp() { return timestamp; }
        public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }

        public String getPath() { return path; }
        public void setPath(String path) { this.path = path; }
    }
}