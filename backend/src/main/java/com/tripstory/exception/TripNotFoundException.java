package com.tripstory.exception;

/**
 * Exception thrown when a requested trip is not found
 */
public class TripNotFoundException extends RuntimeException {
    
    public TripNotFoundException(String message) {
        super(message);
    }
    
    public TripNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}