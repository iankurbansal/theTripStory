#!/bin/bash

# Navigate to consolidated repo
cd /Users/ABANSAL/vscode/vsRepos/theTripStory-pages

echo "🔒 Setting up secure .gitignore..."
cp /Users/ABANSAL/vscode/vsRepos/tripStory/secure_gitignore.txt .gitignore

echo "📝 Creating main README..."
cp /Users/ABANSAL/vscode/vsRepos/tripStory/create_main_readme.md README.md

echo "🗑️ Removing any sensitive files (if any)..."
find . -name "*.env" -delete 2>/dev/null || true
find . -name "*secrets*" -delete 2>/dev/null || true
find . -name "firebase-service-account.json" -delete 2>/dev/null || true

echo "📋 Current repository structure:"
ls -la

echo ""
echo "🔐 Security check - These files should NOT be present:"
echo "❌ .env files: $(find . -name "*.env" | wc -l) found"
echo "❌ Secret files: $(find . -name "*secret*" | wc -l) found"  
echo "❌ Service accounts: $(find . -name "*service-account*" | wc -l) found"

echo ""
echo "📦 Adding files to git..."
git add .

echo "💾 Committing consolidated repository..."
git commit -m "Consolidate tripStory into single repository

- Move backend Spring Boot application
- Add frontend Flutter source code  
- Maintain webapp/ for GitHub Pages
- Create mobile/ directory for future iOS/Android
- Add comprehensive .gitignore for security
- Update README with full project documentation

🚀 Ready for Railway deployment!

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo "🚀 Pushing to GitHub..."
git push

echo "✅ Repository consolidation complete!"
echo ""
echo "🎯 Next steps:"
echo "1. Create Railway account"
echo "2. Deploy backend to Railway"
echo "3. Update frontend API URL"
echo ""
echo "🔗 Repository: https://github.com/iankurbansal/theTripStory"