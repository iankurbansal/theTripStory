#!/bin/bash

echo "🔧 Fixing Maven wrapper issue..."

# Copy updated Railway config
cp /Users/ABANSAL/vscode/vsRepos/tripStory/railway_system_maven.toml /Users/ABANSAL/vscode/vsRepos/theTripStory-pages/railway.toml

# Navigate to repo and commit
cd /Users/ABANSAL/vscode/vsRepos/theTripStory-pages

echo "💾 Committing Maven fix..."
git add railway.toml
git commit -m "Fix Maven wrapper issue - use system Maven

- Install Maven during build phase
- Use system mvn instead of ./mvnw  
- Should resolve 'mvnw: No such file or directory' error

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo "🚀 Pushing Maven fix..."
git push

echo "✅ Maven fix pushed! Railway should install Maven and build successfully."