# Claude Instructions for TripStory Project

## Access Restrictions
- Only work within the current project directory: `/Users/ABANSAL/vscode/vsRepos/tripStory`
- Do not access files outside this project unless explicitly requested

## Project Context
This is a travel planning app with:
- **Backend**: Java Spring Boot with Mapbox integration for destination search
- **Frontend**: Flutter mobile app
- **Features**: Trip creation, destination autocomplete using Mapbox API

## Deployment & Repository
- **Repository**: Public GitHub repo at https://github.com/iankurbansal/theTripStory.git
- **Backend**: Deployed on Railway
- **Frontend**: Hosted on GitHub
- **Authentication**: Firebase Auth integration

## Mapbox Integration Status
- Backend has MapboxService and destination search API at `/api/destinations/search`
- Frontend has DestinationSearchWidget integrated into create trip screen
- Need to set MAPBOX_ACCESS_TOKEN environment variable for full functionality

## Development Commands
```bash
# Backend
cd backend && mvn spring-boot:run

# Frontend  
cd frontend && flutter run
```

## Current Work
- Mapbox destination autocomplete is implemented
- Users need to get Mapbox API key and set MAPBOX_ACCESS_TOKEN environment variable