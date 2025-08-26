#!/bin/bash

echo "📝 Adding Railway configuration..."

# Copy Railway config to the consolidated repo
cp /Users/ABANSAL/vscode/vsRepos/tripStory/railway.toml /Users/ABANSAL/vscode/vsRepos/theTripStory-pages/

# Navigate to repo and commit
cd /Users/ABANSAL/vscode/vsRepos/theTripStory-pages

echo "🔍 Adding railway.toml..."
git add railway.toml

echo "💾 Committing Railway configuration..."
git commit -m "Add Railway configuration for Java/Maven deployment

- Use NIXPACKS with Java 17
- Configure Maven wrapper (./mvnw) instead of system mvn  
- Set proper build and start commands for backend deployment

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo "🚀 Pushing to GitHub..."
git push

echo "✅ Railway config added! This will trigger auto-deployment."