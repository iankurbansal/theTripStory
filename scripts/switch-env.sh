#!/bin/bash

# TripStory Environment Switcher
# Usage: ./switch-env.sh [local|remote]

if [ -z "$1" ]; then
    echo "Usage: ./switch-env.sh [local|remote]"
    echo "Current profile: ${FLUTTER_PROFILE:-local}"
    exit 1
fi

PROFILE=$1

if [ "$PROFILE" = "local" ]; then
    echo "🏠 Switching to LOCAL environment"
    echo "   - API: http://localhost:8080/api"
    echo "   - Backend: Local Spring Boot server"
    export FLUTTER_PROFILE=local
    cd frontend && flutter run -d chrome --web-port 3000 --dart-define=FLUTTER_PROFILE=local
    
elif [ "$PROFILE" = "remote" ]; then
    echo "🌐 Switching to REMOTE environment"
    echo "   - API: https://thetripstory-production.up.railway.app/api" 
    echo "   - Backend: Railway deployed server"
    export FLUTTER_PROFILE=remote
    cd frontend && flutter run -d chrome --web-port 3000 --dart-define=FLUTTER_PROFILE=remote
    
else
    echo "❌ Invalid profile: $PROFILE"
    echo "Use: local or remote"
    exit 1
fi