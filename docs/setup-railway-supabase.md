# Railway + Supabase Setup Guide

## ✅ Frontend Status: 
- **Switched to Railway backend**: `https://thetripstory-production.up.railway.app/api`

## 🔧 Next Steps for Supabase Integration:

### 1. Get Supabase Credentials
Go to your Supabase project dashboard and collect:

**From Settings > Database:**
```
Host: db.[YOUR-PROJECT-REF].supabase.co
Port: 5432
Database: postgres
User: postgres  
Password: [YOUR-PASSWORD]
```

**Or the full connection string:**
```
postgresql://postgres:[password]@db.[project-ref].supabase.co:5432/postgres
```

### 2. Update Railway Environment Variables
In Railway dashboard → Your Service → Variables, add/update:

```bash
# Database (Supabase)
DATABASE_URL=postgresql://postgres:[password]@db.[project-ref].supabase.co:5432/postgres
DATABASE_DRIVER=org.postgresql.Driver
DATABASE_PLATFORM=org.hibernate.dialect.PostgreSQLDialect
DDL_AUTO=update
H2_CONSOLE_ENABLED=false
SHOW_SQL=false

# Existing variables to keep
MAPBOX_ACCESS_TOKEN=your_mapbox_token
FIREBASE_PROJECT_ID=tripstory-1f299
UNSPLASH_ACCESS_KEY=your_unsplash_key
```

### 3. Optional: Add Supabase API Keys (for future features)
```bash
SUPABASE_URL=https://[project-ref].supabase.co
SUPABASE_ANON_KEY=[anon-key]
```

### 4. Redeploy Railway Service
After updating environment variables, trigger a new deployment in Railway.

## 📊 Current Status:
- ✅ Frontend: Switched to Railway backend
- ⏳ Backend: Needs Supabase credentials in Railway
- 💰 Cost Savings: Will eliminate Railway PostgreSQL costs

## 🔍 Testing:
Once Supabase is configured, the app will:
1. Connect to Railway backend
2. Railway backend connects to Supabase database
3. Save ~$5-10/month on database costs