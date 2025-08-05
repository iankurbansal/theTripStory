package com.tripstory.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * Service for integrating with Mapbox Geocoding API
 * 
 * Provides destination search and autocomplete functionality
 * using Mapbox's powerful location search capabilities
 */
@Service
public class MapboxService {

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;
    
    @Value("${mapbox.access-token:}")
    private String accessToken;
    
    private static final String MAPBOX_GEOCODING_URL = "https://api.mapbox.com/geocoding/v5/mapbox.places";

    public MapboxService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    /**
     * Search for destinations based on query string
     * @param query Search query (e.g., "Paris", "New York City", "Tokyo")
     * @param limit Maximum number of results (default: 5)
     * @return List of destination suggestions
     */
    public List<DestinationSuggestion> searchDestinations(String query, Integer limit) {
        if (query == null || query.trim().isEmpty()) {
            return new ArrayList<>();
        }

        if (accessToken == null || accessToken.isEmpty()) {
            System.err.println("Mapbox access token not configured");
            return getFallbackSuggestions(query);
        }

        try {
            String encodedQuery = URLEncoder.encode(query.trim(), StandardCharsets.UTF_8);
            int searchLimit = limit != null ? Math.min(limit, 10) : 5;
            
            String url = String.format("%s/%s.json?access_token=%s&limit=%d&types=place,country,region,postcode,locality",
                    MAPBOX_GEOCODING_URL, encodedQuery, accessToken, searchLimit);

            System.out.println("Searching Mapbox for: " + query);
            String response = restTemplate.getForObject(url, String.class);
            
            return parseMapboxResponse(response);

        } catch (Exception e) {
            System.err.println("Error searching Mapbox: " + e.getMessage());
            return getFallbackSuggestions(query);
        }
    }

    /**
     * Parse Mapbox API response and convert to destination suggestions
     */
    private List<DestinationSuggestion> parseMapboxResponse(String response) {
        List<DestinationSuggestion> suggestions = new ArrayList<>();

        try {
            JsonNode root = objectMapper.readTree(response);
            JsonNode features = root.get("features");

            if (features != null && features.isArray()) {
                for (JsonNode feature : features) {
                    String placeName = feature.get("place_name").asText();
                    String text = feature.get("text").asText();
                    
                    // Get coordinates
                    JsonNode center = feature.get("center");
                    Double longitude = center != null ? center.get(0).asDouble() : null;
                    Double latitude = center != null ? center.get(1).asDouble() : null;
                    
                    // Get place type
                    JsonNode placeType = feature.get("place_type");
                    String type = placeType != null && placeType.isArray() && placeType.size() > 0 
                            ? placeType.get(0).asText() : "place";

                    suggestions.add(new DestinationSuggestion(
                            text,           // Short name
                            placeName,      // Full name with context
                            type,           // Place type
                            latitude,       // Latitude
                            longitude       // Longitude
                    ));
                }
            }

        } catch (Exception e) {
            System.err.println("Error parsing Mapbox response: " + e.getMessage());
        }

        return suggestions;
    }

    /**
     * Fallback suggestions when Mapbox is unavailable
     */
    private List<DestinationSuggestion> getFallbackSuggestions(String query) {
        List<DestinationSuggestion> fallback = new ArrayList<>();
        
        // Add the user's query as a basic suggestion
        fallback.add(new DestinationSuggestion(
                query, 
                query, 
                "place", 
                null, 
                null
        ));

        // Add some popular destinations if query matches
        String lowerQuery = query.toLowerCase();
        if (lowerQuery.contains("paris")) {
            fallback.add(new DestinationSuggestion("Paris", "Paris, France", "place", 48.8566, 2.3522));
        } else if (lowerQuery.contains("tokyo")) {
            fallback.add(new DestinationSuggestion("Tokyo", "Tokyo, Japan", "place", 35.6762, 139.6503));
        } else if (lowerQuery.contains("new york")) {
            fallback.add(new DestinationSuggestion("New York", "New York, NY, USA", "place", 40.7128, -74.0060));
        } else if (lowerQuery.contains("london")) {
            fallback.add(new DestinationSuggestion("London", "London, England, UK", "place", 51.5074, -0.1278));
        }

        return fallback;
    }

    /**
     * Data class for destination suggestions
     */
    public static class DestinationSuggestion {
        private final String name;
        private final String fullName;
        private final String type;
        private final Double latitude;
        private final Double longitude;

        public DestinationSuggestion(String name, String fullName, String type, Double latitude, Double longitude) {
            this.name = name;
            this.fullName = fullName;
            this.type = type;
            this.latitude = latitude;
            this.longitude = longitude;
        }

        // Getters
        public String getName() { return name; }
        public String getFullName() { return fullName; }
        public String getType() { return type; }
        public Double getLatitude() { return latitude; }
        public Double getLongitude() { return longitude; }
    }
}