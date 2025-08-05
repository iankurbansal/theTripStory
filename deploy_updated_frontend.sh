#!/bin/bash

echo "🚀 Deploying updated frontend with Railway API..."

# Copy built frontend to GitHub Pages repo
cp -r build/web/* /Users/ABANSAL/vscode/vsRepos/theTripStory-pages/webapp/

# Navigate to GitHub Pages repo
cd /Users/ABANSAL/vscode/vsRepos/theTripStory-pages

# Commit and push updated frontend
git add .
git commit -m "Update frontend to use Railway backend API

- Update API service to point to Railway deployment  
- Backend now live at: https://thetripstory-production.up.railway.app
- Firebase authentication + Railway backend integration complete
- Ready for end-to-end testing with public API

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

git push

echo "✅ Frontend deployed with Railway API URL!"
echo ""
echo "🎉 INFRASTRUCTURE COMPLETE!"
echo "🌐 Frontend: https://thetripstory.com/webapp"  
echo "🚀 Backend: https://thetripstory-production.up.railway.app"
echo "🔥 Firebase: Fully integrated authentication"
echo ""
echo "🎯 Ready to test full stack application!"