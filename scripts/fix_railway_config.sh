#!/bin/bash

echo "🔧 Fixing Railway configuration..."

# Copy fixed Railway config
cp /Users/ABANSAL/vscode/vsRepos/tripStory/railway_fixed.toml /Users/ABANSAL/vscode/vsRepos/theTripStory-pages/railway.toml

# Navigate to repo and commit
cd /Users/ABANSAL/vscode/vsRepos/theTripStory-pages

echo "💾 Committing fixed Railway configuration..."
git add railway.toml
git commit -m "Fix Railway configuration TOML syntax

- Fix buildCommand syntax error
- Correct TOML format for Railway deployment
- Should now properly build Java 17 + Maven project

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo "🚀 Pushing fixed config..."
git push

echo "✅ Fixed Railway config pushed!"