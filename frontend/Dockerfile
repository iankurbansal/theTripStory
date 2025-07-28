# Multi-stage Dockerfile for TripStory Frontend (Flutter Web)

# Stage 1: Build the Flutter web application
FROM ghcr.io/cirruslabs/flutter:latest AS builder

# Fix Git ownership issue
RUN git config --global --add safe.directory /sdks/flutter

# Set working directory
WORKDIR /app

# Copy pubspec files first (for better layer caching)
COPY pubspec.yaml pubspec.lock ./

# Get Flutter dependencies
RUN flutter pub get

# Copy the rest of the source code
COPY . .

# Enable Flutter web
RUN flutter config --enable-web

# Build the Flutter web app for production
RUN flutter build web --release

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Remove default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy built Flutter web app from builder stage
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create nginx user if it doesn't exist and set permissions
RUN addgroup -g 101 -S nginx || true && \
    adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx || true && \
    chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:80/ || exit 1

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

# Labels for better container management
LABEL maintainer="TripStory Team" \
      version="1.0.0" \
      description="TripStory Frontend - Flutter web application for travel planning"