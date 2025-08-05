#!/bin/bash

# TripStory Backend Deployment Script for GCP Cloud Run

set -e

# Configuration
PROJECT_ID=${PROJECT_ID:-"tripstory-1f299"}
REGION=${REGION:-"us-central1"}
SERVICE_NAME="tripstory-backend"
IMAGE_NAME="gcr.io/$PROJECT_ID/$SERVICE_NAME"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Deploying TripStory Backend to Cloud Run${NC}"

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ gcloud CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if logged in to gcloud
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo -e "${YELLOW}⚠️  Not logged in to gcloud. Please run: gcloud auth login${NC}"
    exit 1
fi

# Set the project
echo -e "${YELLOW}📋 Setting GCP project: $PROJECT_ID${NC}"
gcloud config set project $PROJECT_ID

# Enable required APIs
echo -e "${YELLOW}🔧 Enabling required GCP APIs...${NC}"
gcloud services enable \
    cloudbuild.googleapis.com \
    run.googleapis.com \
    containerregistry.googleapis.com

# Build and deploy using Cloud Build
echo -e "${YELLOW}🏗️  Building and deploying with Cloud Build...${NC}"
gcloud builds submit --config=cloudbuild.yaml ..

# Get the service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)")

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${GREEN}🌐 Service URL: $SERVICE_URL${NC}"
echo -e "${GREEN}📊 Health Check: $SERVICE_URL/actuator/health${NC}"
echo -e "${GREEN}📖 API Docs: $SERVICE_URL/swagger-ui.html${NC}"

echo -e "${YELLOW}📝 Next Steps:${NC}"
echo -e "1. Set up your Supabase database connection:"
echo -e "   gcloud run services update $SERVICE_NAME --region=$REGION \\"
echo -e "     --set-env-vars=DATABASE_URL=jdbc:postgresql://[HOST]:[PORT]/[DATABASE] \\"
echo -e "     --set-env-vars=DATABASE_USERNAME=[USERNAME] \\"
echo -e "     --set-env-vars=DATABASE_PASSWORD=[PASSWORD]"
echo -e ""
echo -e "2. Update CORS origins:"
echo -e "   gcloud run services update $SERVICE_NAME --region=$REGION \\"
echo -e "     --set-env-vars=FRONTEND_URL=https://your-frontend-domain.com"