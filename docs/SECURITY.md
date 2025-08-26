# Security Configuration Guide

## Overview
This document outlines the security configuration required to run TripStory safely in production.

## Environment Variables Setup

### 1. Database Configuration
Set these variables in your deployment environment:
```
DATABASE_URL=jdbc:postgresql://your-db-host:5432/your-database
DATABASE_USERNAME=your-db-username  
DATABASE_PASSWORD=your-secure-password
```

### 2. Firebase Configuration
Configure these Firebase variables:
```
FIREBASE_API_KEY=your-firebase-api-key
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project.firebasestorage.app
FIREBASE_MESSAGING_SENDER_ID=your-sender-id
FIREBASE_APP_ID=your-app-id
FIREBASE_MEASUREMENT_ID=your-measurement-id
```

### 3. Mapbox Configuration
```
MAPBOX_ACCESS_TOKEN=pk.your-mapbox-public-token
```

## Platform-Specific Setup

### Railway Deployment
1. Go to your Railway project dashboard
2. Navigate to Variables tab
3. Add all required environment variables
4. Deploy with secure configuration

### Google Cloud Build
1. Configure secret environment variables in Google Cloud Console
2. Use Cloud Build substitutions for sensitive data
3. Never hardcode credentials in cloudbuild.yaml

### GitHub Pages (Frontend)
1. Use GitHub Secrets for environment variables
2. Configure build action to inject secrets during compilation
3. Use GitHub Actions environment contexts

## Firebase Security
1. **API Key Restrictions**: In Google Cloud Console, restrict your Firebase API key to specific apps/websites
2. **Authorized Domains**: Add only your production domains to Firebase Auth authorized domains
3. **Security Rules**: Configure Firestore/Storage security rules to restrict access

## Database Security
1. Use strong, unique passwords
2. Enable SSL/TLS connections
3. Restrict database access to specific IP ranges
4. Regularly rotate credentials
5. Use least-privilege principle for database users

## Best Practices
- Never commit `.env` files
- Rotate secrets regularly
- Use different credentials for dev/staging/prod
- Monitor for exposed secrets with tools like git-secrets
- Regular security audits

## Emergency Procedures
If credentials are accidentally exposed:
1. Immediately rotate all exposed credentials
2. Review access logs for unauthorized usage
3. Update all deployment environments with new credentials
4. Remove sensitive data from git history if necessary

## Contact
For security concerns, please follow responsible disclosure practices.