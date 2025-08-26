#!/bin/bash

echo "🐳 Switching to Docker-based deployment..."

# Copy Docker files to the consolidated repo
cp /Users/ABANSAL/vscode/vsRepos/tripStory/Dockerfile_railway /Users/ABANSAL/vscode/vsRepos/theTripStory-pages/Dockerfile
cp /Users/ABANSAL/vscode/vsRepos/tripStory/railway_docker.toml /Users/ABANSAL/vscode/vsRepos/theTripStory-pages/railway.toml

# Navigate to repo and commit
cd /Users/ABANSAL/vscode/vsRepos/theTripStory-pages

echo "📁 Files added:"
echo "- Dockerfile (Maven + Java 17)"
echo "- railway.toml (Docker builder)"

echo "💾 Committing Docker deployment..."
git add Dockerfile railway.toml
git commit -m "Switch to Docker-based deployment for Railway

- Add Dockerfile with Maven 3.9 + Java 17
- Use Docker builder instead of NIXPACKS
- Should resolve Maven installation issues
- Multi-stage build for optimal image size

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo "🚀 Pushing Docker deployment..."
git push

echo "✅ Docker deployment pushed! Railway will now build with Docker."
echo "🐳 This should resolve all Maven/Java issues."