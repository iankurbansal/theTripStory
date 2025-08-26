#!/bin/bash

# TripStory Local Development Setup Script

echo "🚀 Setting up TripStory for local development..."

# Check if .env.local exists
if [ ! -f ".env.local" ]; then
    echo "❌ .env.local file not found!"
    echo "Please create .env.local file with your environment variables."
    echo "See .env.local template for reference."
    exit 1
fi

# Source environment variables
echo "📝 Loading environment variables from .env.local..."
source .env.local

# Check if required variables are set
if [ -z "$UNSPLASH_ACCESS_KEY" ] || [ "$UNSPLASH_ACCESS_KEY" = "your_unsplash_access_key_here" ]; then
    echo "⚠️  Warning: UNSPLASH_ACCESS_KEY not set or using default value"
    echo "   Get your API key from: https://unsplash.com/developers"
fi

# Start backend
echo "🔧 Starting backend server..."
cd backend
mvn spring-boot:run &
BACKEND_PID=$!

# Wait a moment for backend to start
sleep 5

# Start frontend in new terminal (if possible)
echo "📱 Starting frontend..."
cd ../frontend
if command -v gnome-terminal &> /dev/null; then
    gnome-terminal -- bash -c "flutter run; exec bash"
elif command -v osascript &> /dev/null; then
    osascript -e 'tell app "Terminal" to do script "cd '$(pwd)' && flutter run"'
else
    echo "Please run 'cd frontend && flutter run' in another terminal"
fi

echo "✅ Setup complete!"
echo "Backend: http://localhost:8080"
echo "Frontend: Check Flutter console for URL"
echo ""
echo "To stop backend: kill $BACKEND_PID"