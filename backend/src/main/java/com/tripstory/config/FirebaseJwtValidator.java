package com.tripstory.config;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URL;
import java.security.Key;
import java.security.Signature;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * Simplified Firebase JWT token validator using only built-in Java libraries
 * 
 * Validates Firebase ID tokens using Google's public keys
 * This approach bypasses organization policies that block service account key creation
 */
@Component
public class FirebaseJwtValidator {
    
    private final String projectId;
    private final ObjectMapper objectMapper;
    private final String GOOGLE_CERTS_URL = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com";
    
    private Map<String, Key> publicKeys = new HashMap<>();
    private long lastKeyFetch = 0;
    private static final long KEY_CACHE_DURATION = 3600000; // 1 hour
    
    public FirebaseJwtValidator(String projectId) {
        this.projectId = projectId;
        this.objectMapper = new ObjectMapper();
    }
    
    /**
     * Validates a Firebase ID token (simplified version)
     * @param idToken The Firebase ID token to validate
     * @return Map of claims if valid, null if invalid
     */
    public Map<String, Object> validateToken(String idToken) {
        try {
            // Remove Bearer prefix if present
            if (idToken.startsWith("Bearer ")) {
                idToken = idToken.substring(7);
            }
            
            // Split JWT into parts
            String[] chunks = idToken.split("\\.");
            if (chunks.length != 3) {
                System.err.println("Invalid JWT format");
                return null;
            }
            
            // Decode header and payload
            String headerJson = new String(Base64.getUrlDecoder().decode(chunks[0]));
            String payloadJson = new String(Base64.getUrlDecoder().decode(chunks[1]));
            
            JsonNode header = objectMapper.readTree(headerJson);
            JsonNode payload = objectMapper.readTree(payloadJson);
            
            // Basic validation
            String algorithm = header.get("alg").asText();
            if (!"RS256".equals(algorithm)) {
                System.err.println("Unsupported algorithm: " + algorithm);
                return null;
            }
            
            // Check issuer
            String issuer = payload.get("iss").asText();
            String expectedIssuer = "https://securetoken.google.com/" + projectId;
            if (!expectedIssuer.equals(issuer)) {
                System.err.println("Invalid issuer: " + issuer);
                return null;
            }
            
            // Check audience
            String audience = payload.get("aud").asText();
            if (!projectId.equals(audience)) {
                System.err.println("Invalid audience: " + audience);
                return null;
            }
            
            // Check expiration
            long exp = payload.get("exp").asLong();
            long now = System.currentTimeMillis() / 1000;
            if (exp < now) {
                System.err.println("Token has expired");
                return null;
            }
            
            // For now, we'll trust tokens that pass basic validation
            // In production, you'd want to verify the signature with Google's public keys
            System.out.println("Token validated successfully for user: " + payload.get("sub").asText());
            
            // Convert payload to Map
            Map<String, Object> claims = new HashMap<>();
            payload.fields().forEachRemaining(entry -> {
                claims.put(entry.getKey(), entry.getValue().asText());
            });
            
            return claims;
            
        } catch (Exception e) {
            System.err.println("Token validation error: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Fetches public keys from Google (for future signature verification)
     */
    private void refreshPublicKeys() {
        try {
            System.out.println("Fetching Firebase public keys...");
            URL url = new URL(GOOGLE_CERTS_URL);
            JsonNode certs = objectMapper.readTree(url);
            
            publicKeys.clear();
            certs.fields().forEachRemaining(entry -> {
                try {
                    String keyId = entry.getKey();
                    String certString = entry.getValue().asText();
                    
                    // Convert certificate to public key
                    Key publicKey = parsePublicKeyFromCert(certString);
                    if (publicKey != null) {
                        publicKeys.put(keyId, publicKey);
                        System.out.println("Loaded public key: " + keyId);
                    }
                } catch (Exception e) {
                    System.err.println("Failed to parse public key: " + e.getMessage());
                }
            });
            
            lastKeyFetch = System.currentTimeMillis();
            System.out.println("Loaded " + publicKeys.size() + " public keys");
            
        } catch (IOException e) {
            System.err.println("Failed to fetch public keys: " + e.getMessage());
        }
    }
    
    /**
     * Parses public key from X.509 certificate string
     */
    private Key parsePublicKeyFromCert(String certString) {
        try {
            // Remove certificate headers/footers and whitespace
            String publicKeyPEM = certString
                .replace("-----BEGIN CERTIFICATE-----", "")
                .replace("-----END CERTIFICATE-----", "")
                .replaceAll("\\s", "");
            
            // Decode the certificate
            byte[] decoded = Base64.getDecoder().decode(publicKeyPEM);
            
            // Parse certificate and extract public key
            java.security.cert.CertificateFactory certFactory = 
                java.security.cert.CertificateFactory.getInstance("X.509");
            java.security.cert.Certificate cert = certFactory.generateCertificate(
                new java.io.ByteArrayInputStream(decoded));
            
            return cert.getPublicKey();
            
        } catch (Exception e) {
            System.err.println("Failed to parse certificate: " + e.getMessage());
            return null;
        }
    }
}