# Claude Instructions for TripStory Project

## Access Restrictions
- Only work within the current project directory: `/Users/ABANSAL/vscode/vsRepos/tripStory`
- Do not access files outside this project unless explicitly requested

## Project Context
This is a travel planning app with:
- **Backend**: Java Spring Boot with Mapbox integration for destination search
- **Frontend**: Flutter web application (not mobile)
- **Features**: Trip creation, destination autocomplete using Mapbox API, Firebase authentication

## Repository & Branching Strategy
- **Repository**: Public GitHub repo at https://github.com/iankurbansal/theTripStory.git
- **Main Branch (`main`)**: Source code with secure environment variable configuration
  - Contains backend Java code, frontend Flutter source code
  - Uses environment variables for all sensitive configuration (Firebase, database credentials)
  - Protected from exposing API keys or secrets
- **GitHub Pages Branch (`gh-pages`)**: Deployed Flutter web application
  - Contains compiled Flutter web assets ready for production
  - Automatically built with secure environment variables via GitHub Actions
  - Serves the live application at https://thetripstory.com and https://iankurbansal.github.io/theTripStory/
  - Updated via GitHub Actions workflow on frontend changes

## Deployment Architecture
- **Backend**: Deployed on Railway with PostgreSQL database
  - Uses environment variables for database credentials and API keys
  - Accessible at Railway-provided URL
- **Frontend**: Deployed via GitHub Pages 
  - Built with Firebase configuration via GitHub Secrets
  - Custom domain: https://thetripstory.com
  - Fallback URL: https://iankurbansal.github.io/theTripStory/
- **Authentication**: Firebase Auth with secure domain configuration

## Security Configuration
- **Environment Variables**: All sensitive data (Firebase config, database credentials, API keys) use environment variables
- **No Exposed Secrets**: Repository is safe for public access with no hardcoded credentials
- **GitHub Secrets**: Firebase configuration injected via GitHub Actions using repository secrets
- **Railway Environment**: Database and API credentials configured in Railway dashboard

## Mapbox Integration Status
- Backend has MapboxService and destination search API at `/api/destinations/search`
- Frontend has DestinationSearchWidget with single-tap selection functionality
- Uses MAPBOX_ACCESS_TOKEN environment variable (configured in Railway)
- Autocomplete feature fully implemented and working

## Development Commands
```bash
# Backend (local development)
cd backend && mvn spring-boot:run

# Frontend (local development)
cd frontend && flutter run -d chrome

# Frontend (build for web)
cd frontend && flutter build web
```

## GitHub Actions Workflow
- **Trigger**: Automatic deployment on changes to `frontend/**` directory
- **Process**: Builds Flutter web app with secure environment variables from GitHub Secrets
- **Output**: Updates `gh-pages` branch with compiled assets
- **Result**: Live deployment at https://thetripstory.com

## Current Status
- ✅ Mapbox destination autocomplete fully implemented and working
- ✅ Firebase authentication configured and functional  
- ✅ Single-tap destination selection (no double-click issues)
- ✅ Secure deployment with no exposed credentials
- ✅ GitHub Pages deployment with custom domain working