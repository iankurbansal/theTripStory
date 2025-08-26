#!/bin/bash

echo "🔍 Adding debug Dockerfile to see what's failing..."

# Copy debug Dockerfile
cp /Users/ABANSAL/vscode/vsRepos/tripStory/Dockerfile_fixed /Users/ABANSAL/vscode/vsRepos/theTripStory-pages/Dockerfile

# Navigate to repo and commit
cd /Users/ABANSAL/vscode/vsRepos/theTripStory-pages

echo "💾 Committing debug Dockerfile..."
git add Dockerfile
git commit -m "Add debug output to Dockerfile build

- Copy entire backend/ directory structure
- Add debug output to see copied files
- Use verbose Maven output (-X) to debug build failure
- Should help identify why Maven build is failing

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo "🚀 Pushing debug version..."
git push

echo "✅ Debug Dockerfile pushed!"
echo "🔍 Check Railway logs for detailed Maven output."