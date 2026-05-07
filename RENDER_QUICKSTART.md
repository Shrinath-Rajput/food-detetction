# 🚀 Render Deployment Quick Start

## What Was Fixed ✅

1. **Model Path Resolution**: Changed from `os.getcwd()` to `__file__` for reliable paths
2. **Lazy Model Loading**: Model now loads on first request, not at startup
3. **Better Error Messages**: Detailed error info at `/api/health` endpoint
4. **render.yaml Config**: Automated Render deployment configuration

## Immediate Steps to Deploy

### Step 1: Verify Git Push ✓
```bash
# All changes are already pushed to GitHub!
# Commit: "Fix Render deployment: lazy load model, improve path resolution, add render.yaml config"
```

### Step 2: Redeploy on Render

**Option A: Auto-Redeploy (Recommended)**
1. Go to https://dashboard.render.com
2. Click your "food-freshness-api" service
3. Click "Manual Deploy" → "Deploy latest commit"
4. Wait 2-3 minutes for build to complete

**Option B: Manual Redeploy**
1. Push any small change: `git commit --allow-empty -m "Trigger Render redeploy"`
2. `git push origin main`
3. Render auto-redeploys on push

### Step 3: Verify Deployment

```bash
# Get your Render URL from dashboard (looks like: https://food-freshness-api-xxxx.onrender.com)

# Test health endpoint
curl https://YOUR_RENDER_URL/api/health

# Should return:
# {
#   "status": "OK",
#   "model_loaded": true,
#   "model_path": "/opt/render/project/artifacts/model.tflite"
# }

# Test prediction (with a test image)
curl -X POST https://YOUR_RENDER_URL/api/predict \
  -F "image=@test.jpg"
```

## If It Still Fails

### Check Build Logs
1. Dashboard → Your Service
2. "Logs" tab
3. Look for errors during build

### Common Issues & Fixes

**Issue: `tflite-runtime` not found**
- Already fixed! The lazy loading handles this better

**Issue: Model still not found**
- Verify model files are in Git: `git ls-files artifacts/`
- Check Render has latest commit: Dashboard shows commit hash

**Issue: 503 Service Unavailable**
- App is starting up, wait 1-2 minutes
- Check `/api/health` endpoint for specific errors

### Force Full Redeploy

1. Go to Dashboard → Settings → General
2. Click "Disconnect Repository"
3. Reconnect your GitHub repo
4. Deploy latest

## Key Changes Made

### app.py
- Lazy loads model on first `/api/predict` request
- Better error handling and logging
- `/api/health` endpoint shows model status

### predict_pipeline.py
- Better error messages with absolute paths
- Handles missing files gracefully

### render.yaml
- Auto-configuration for Render
- Proper Python 3.11 setup
- Correct build and start commands

## Testing Locally Before Deploy

```bash
# Test locally to verify it works
python app.py

# In another terminal:
curl http://localhost:10000/api/health
curl -X POST http://localhost:10000/api/predict -F "image=@test.jpg"
```

## Deployment URLs

- **API Health**: `https://YOUR_APP.onrender.com/api/health`
- **Predict Endpoint**: `https://YOUR_APP.onrender.com/api/predict`
- **Home**: `https://YOUR_APP.onrender.com/`

## Still Having Issues?

1. Check logs: `Dashboard → Logs tab`
2. Check health: `curl https://YOUR_APP.onrender.com/api/health`
3. Verify models exist: Check artifacts/ folder in repo
4. Redeploy: Click "Manual Deploy" in Dashboard

---

✅ **Status**: All fixes committed to GitHub and pushed to main branch
🚀 **Next**: Trigger redeploy on Render Dashboard
