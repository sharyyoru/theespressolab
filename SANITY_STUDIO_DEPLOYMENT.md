# Sanity Studio Vercel Deployment

## ✅ Configuration Complete

Sanity Studio is ready to deploy with:
- `vercel.json` configured
- `vercel-build` script added to package.json
- Build tested successfully (dist folder generated)

## 🚀 Deploy to Vercel (Two Options)

### Option 1: Import via Vercel Dashboard (Recommended)

1. Go to https://vercel.com/new
2. Click "Import Git Repository"
3. Select your repository: `sharyyoru/theespressolab`
4. **Important**: Configure the root directory
   - Set **Root Directory** to: `sanity`
5. Click "Deploy"

**Your Sanity Studio will be live at:**
`https://theespressolab-sanity.vercel.app` (or similar)

### Option 2: Deploy via CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Navigate to sanity folder
cd sanity

# Deploy
vercel

# Follow prompts:
# - Link to existing project? No
# - Project name: theespressolab-sanity
# - Root directory: ./
```

## 🔧 After Deployment

### 1. Add Production URL to Sanity CORS
Go to https://sanity.io/manage → Select project → API → CORS Origins

Add:
- Your production URL: `https://theespressolab-sanity.vercel.app`
- Main frontend URL: `https://theespressolab.vercel.app`

### 2. Update Frontend Environment Variables
In your main frontend Vercel project, ensure:
```
REACT_APP_SANITY_PROJECT_ID=gyft0w2o
REACT_APP_SANITY_DATASET=production
```

## 📍 Expected URLs

After deployment:

**Sanity Studio (CMS)**: 
- Production: `https://theespressolab-sanity.vercel.app`
- Access this to manage content

**Frontend (Website)**:
- Production: `https://theespressolab.vercel.app`
- Public-facing website

## 🎯 Quick Start After Deployment

1. Visit your Sanity Studio URL
2. Login with your Sanity account
3. Start adding content:
   - Site Settings (logo, favicon)
   - Categories
   - Collections
   - Products

Content will automatically sync to your frontend via Sanity's API.

## 🔑 Login Credentials

Use your Sanity account credentials (the one you used to create the project with ID: `gyft0w2o`)

## ⚠️ Important Notes

- Sanity Studio and Frontend are **separate deployments**
- Both need separate Vercel projects
- CORS must allow Studio URL to connect to Sanity API
- Changes in Studio are instant (no rebuild needed)
- Frontend fetches data via API calls

## 🐛 Troubleshooting

**Can't login to Studio:**
- Check CORS origins include your Studio URL
- Verify project ID matches in config

**Content not showing on frontend:**
- Check frontend environment variables
- Verify CORS includes frontend URL
- Check browser console for API errors

## 📞 Support

Project ID: `gyft0w2o`
Dataset: `production`
Studio Config: `/sanity/sanity.config.ts`
