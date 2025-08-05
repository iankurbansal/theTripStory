package com.tripstory.config;

import java.util.Map;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;

/**
 * Firebase JWT token authentication filter
 * 
 * Validates Firebase ID tokens using direct JWT validation (no Firebase Admin SDK required)
 * This approach works with organization policies that block service account key creation
 */
@Component
public class FirebaseAuthFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(FirebaseAuthFilter.class);
    private static final String BEARER_PREFIX = "Bearer ";
    
    @Autowired
    private FirebaseJwtValidator jwtValidator;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        
        String authHeader = request.getHeader("Authorization");
        
        if (authHeader != null && authHeader.startsWith(BEARER_PREFIX)) {
            String idToken = authHeader.substring(BEARER_PREFIX.length());
            
            // Validate the Firebase ID token using our custom validator
            Map<String, Object> claims = jwtValidator.validateToken(idToken);
            
            if (claims != null) {
                String uid = (String) claims.get("sub");
                String email = (String) claims.get("email");
                
                logger.info("Authenticated user: {} ({})", email, uid);
                
                // Create Spring Security authentication
                UsernamePasswordAuthenticationToken authentication = 
                    new UsernamePasswordAuthenticationToken(uid, null, new ArrayList<>());
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                
                // Set authentication in Spring Security context
                SecurityContextHolder.getContext().setAuthentication(authentication);
            } else {
                logger.warn("Invalid Firebase token");
                // Don't set authentication - request will be rejected by security config
            }
        }
        
        filterChain.doFilter(request, response);
    }
}