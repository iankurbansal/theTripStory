#!/bin/bash

# Deploy updated frontend to GitHub Pages
cd /Users/ABANSAL/vscode/vsRepos/theTripStory-pages

echo "Adding files to git..."
git add .

echo "Committing changes..."
git commit -m "Update frontend with Firebase authentication and new backend URL

- Updated API service to point to new backend deployment
- Firebase authentication fully integrated
- CORS configuration tested and working
- Ready for authenticated API calls

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo "Pushing to GitHub Pages..."
git push

echo "Frontend deployment complete!"
echo "Visit: https://thetripstory.com/webapp"