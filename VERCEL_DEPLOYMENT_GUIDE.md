# Vercel Deployment Guide

## Frontend Deployment

### Environment Variables (Add in Vercel Dashboard)
Go to Project Settings → Environment Variables and add:

```
REACT_APP_SUPABASE_URL=your_supabase_url
REACT_APP_SUPABASE_ANON_KEY=your_supabase_anon_key
REACT_APP_SANITY_PROJECT_ID=your_sanity_project_id
REACT_APP_SANITY_DATASET=production
REACT_APP_STRIPE_PUBLIC_KEY=your_stripe_public_key
```

### Build Settings (Already configured in vercel.json)
- Build Command: `cd frontend && npm install && npm run build`
- Output Directory: `frontend/build`
- Install Command: `cd frontend && npm install`

## Sanity Studio Deployment

Sanity Studio needs to be deployed separately to Sanity's hosting:

### Step 1: Install Sanity CLI
```bash
npm install -g @sanity/cli
```

### Step 2: Login to Sanity
```bash
sanity login
```

### Step 3: Deploy Sanity Studio
```bash
cd sanity
sanity deploy
```

You'll be prompted to choose a studio hostname, e.g., `theespressolab-studio`

Your Sanity Studio will be accessible at:
**https://theespressolab-studio.sanity.studio**

### Step 4: Add CORS Origins in Sanity
Go to https://sanity.io/manage and add these origins:
- `http://localhost:3000` (development)
- `https://theespressolab.vercel.app` (production)
- Your custom domain if you have one

## Deployment URLs

### Frontend (Vercel)
- Production: https://theespressolab.vercel.app
- Git branch deployments: https://theespressolab-git-[branch].vercel.app

### Sanity Studio
- Production: https://[your-studio-name].sanity.studio

## Troubleshooting

### 404 Error on Vercel
- Ensure `vercel.json` is in the root directory
- Check environment variables are set in Vercel dashboard
- Verify build logs show successful React build

### Sanity Content Not Loading
- Check CORS origins in Sanity dashboard
- Verify `REACT_APP_SANITY_PROJECT_ID` is correct
- Ensure Sanity dataset is set to `production`

### Images Not Loading
- Check Supabase storage bucket policies
- Verify bucket URLs are correct
- Ensure images are uploaded to correct buckets

## Custom Domain Setup

1. Go to Vercel Project Settings → Domains
2. Add your custom domain
3. Update DNS records as instructed
4. Add custom domain to Sanity CORS origins
