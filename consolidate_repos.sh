#!/bin/bash

echo "🔄 Consolidating repos into theTripStory..."

# Set paths
TRIPSTORY_PATH="/Users/ABANSAL/vscode/vsRepos/tripStory"
THETRIPSTORY_PATH="/Users/ABANSAL/vscode/vsRepos/theTripStory-pages"

# Navigate to theTripStory repo
cd "$THETRIPSTORY_PATH"

echo "📁 Creating new directory structure..."

# Create backend directory and copy all backend code
echo "📦 Moving backend code..."
cp -r "$TRIPSTORY_PATH/backend" .

# Copy other useful project files
echo "📝 Copying project files..."
cp "$TRIPSTORY_PATH/README.md" ./README_backend.md
cp "$TRIPSTORY_PATH/.gitignore" ./backend/.gitignore

# Copy frontend source (not just built files)
echo "🎨 Moving frontend source..."
cp -r "$TRIPSTORY_PATH/frontend" .
cp -r "$TRIPSTORY_PATH/lib" ./frontend/ 2>/dev/null || echo "lib already in frontend"
cp -r "$TRIPSTORY_PATH/pubspec.yaml" ./frontend/ 2>/dev/null || echo "pubspec already in frontend"
cp -r "$TRIPSTORY_PATH/pubspec.lock" ./frontend/ 2>/dev/null || echo "pubspec.lock already in frontend"

# Create mobile directory for future
echo "📱 Creating mobile directory for future iOS/Android..."
mkdir -p mobile
echo "# Mobile Apps (iOS/Android)" > mobile/README.md
echo "Future home for iOS and Android applications" >> mobile/README.md

echo "✅ Consolidation complete!"
echo ""
echo "📂 New structure:"
echo "theTripStory/"
echo "├── backend/          # Spring Boot API"
echo "├── frontend/         # Flutter source"
echo "├── webapp/           # GitHub Pages (built files)"
echo "├── mobile/           # Future iOS/Android"
echo "├── CNAME            # Domain config"
echo "└── README.md        # Main project readme"
echo ""
echo "🔒 Next: Update .gitignore for security"