package com.tripstory.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@Service
public class UnsplashService {
    
    private static final Logger logger = LoggerFactory.getLogger(UnsplashService.class);
    private static final String UNSPLASH_API_URL = "https://api.unsplash.com";
    
    private final WebClient webClient;
    
    @Value("${unsplash.api.access-key:demo}")
    private String accessKey;
    
    public UnsplashService() {
        this.webClient = WebClient.builder()
                .baseUrl(UNSPLASH_API_URL)
                .build();
    }
    
    public UnsplashPhoto fetchPhotoForDestination(String destination) {
        try {
            logger.info("Fetching photo for destination: {}", destination);
            
            UnsplashSearchResponse response = webClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/search/photos")
                            .queryParam("query", destination + " travel")
                            .queryParam("per_page", 1)
                            .queryParam("orientation", "landscape")
                            .build())
                    .header("Authorization", "Client-ID " + accessKey)
                    .retrieve()
                    .bodyToMono(UnsplashSearchResponse.class)
                    .block();
            
            if (response != null && response.results != null && !response.results.isEmpty()) {
                UnsplashPhoto photo = response.results.get(0);
                logger.info("Successfully fetched photo for destination: {}", destination);
                return photo;
            } else {
                logger.warn("No photos found for destination: {}", destination);
                return null;
            }
        } catch (Exception e) {
            logger.error("Error fetching photo for destination: {}", destination, e);
            return null;
        }
    }
    
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class UnsplashSearchResponse {
        @JsonProperty("results")
        public java.util.List<UnsplashPhoto> results;
    }
    
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class UnsplashPhoto {
        @JsonProperty("id")
        public String id;
        
        @JsonProperty("urls")
        public UnsplashUrls urls;
        
        @JsonProperty("user")
        public UnsplashUser user;
        
        @JsonProperty("links")
        public UnsplashLinks links;
    }
    
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class UnsplashUrls {
        @JsonProperty("small")
        public String small;
        
        @JsonProperty("regular")
        public String regular;
    }
    
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class UnsplashUser {
        @JsonProperty("name")
        public String name;
        
        @JsonProperty("username")
        public String username;
    }
    
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class UnsplashLinks {
        @JsonProperty("html")
        public String html;
    }
}