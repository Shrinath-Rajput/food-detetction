# 🔧 Complete Fix Guide - Database & Prediction Flow

## Problem Summary
- Database table missing `predicted_class` and other required columns
- Dashboard, Records, and Stats endpoints failing due to missing columns
- Need to establish complete end-to-end prediction workflow

## Step-by-Step Solution

### Step 1: Fix Database Schema

#### Option A: Fresh Start (Recommended)
Run this in MySQL Workbench or MySQL Command Line:

```sql
-- Drop old tables and recreate
USE mysql;
DROP DATABASE IF EXISTS food_db;
CREATE DATABASE food_db;
USE food_db;

CREATE TABLE results (
  id INT AUTO_INCREMENT PRIMARY KEY,
  image VARCHAR(255) NOT NULL,
  result LONGTEXT NOT NULL,
  predicted_class VARCHAR(50) NOT NULL,
  confidence FLOAT NOT NULL,
  product_name VARCHAR(100) NOT NULL,
  freshness VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_created (created_at),
  INDEX idx_class (predicted_class),
  INDEX idx_freshness (freshness)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Verify tables
SHOW TABLES;
DESCRIBE results;
```

#### Option B: Add Missing Columns to Existing Table
If you want to keep existing data:

```sql
USE food_db;

-- Add missing columns if they don't exist
ALTER TABLE results 
ADD COLUMN IF NOT EXISTS predicted_class VARCHAR(50) DEFAULT 'unknown',
ADD COLUMN IF NOT EXISTS confidence FLOAT DEFAULT 0.0,
ADD COLUMN IF NOT EXISTS product_name VARCHAR(100) DEFAULT 'unknown',
ADD COLUMN IF NOT EXISTS freshness VARCHAR(20) DEFAULT 'unknown';

-- Create proper indexes
CREATE INDEX IF NOT EXISTS idx_predicted_class ON results(predicted_class);
CREATE INDEX IF NOT EXISTS idx_created_at ON results(created_at);
CREATE INDEX IF NOT EXISTS idx_freshness ON results(freshness);

-- Update existing rows with default values if columns are empty
UPDATE results SET predicted_class = 'unknown' WHERE predicted_class IS NULL OR predicted_class = '';
UPDATE results SET confidence = 0 WHERE confidence IS NULL;
UPDATE results SET product_name = 'unknown' WHERE product_name IS NULL OR product_name = '';
UPDATE results SET freshness = 'unknown' WHERE freshness IS NULL OR freshness = '';

-- Verify
DESCRIBE results;
SELECT COUNT(*) as total_records FROM results;
```

### Step 2: Verify Database Connection

Make sure your `.env` file (or Backend/.env) contains:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=shrinath1814
DB_NAME=food_db
PORT=5000
FLASK_API_URL=http://localhost:8000
NODE_ENV=development
```

### Step 3: Restart Services

**Terminal 1 - Start Flask API (Port 8000):**
```bash
cd "Food freshness classification from visual features"
python app.py
```

Wait for it to show:
```
✓ Model loaded successfully
FOOD FRESHNESS CLASSIFICATION API
```

**Terminal 2 - Start Node.js Server (Port 5000):**
```bash
cd "Food freshness classification from visual features\Backend"
npm install  # If not already installed
npm start
```

Wait for it to show:
```
✓ Server running on: http://localhost:5000
✓ Database connected successfully
✓ Database tables ready
```

### Step 4: Complete Prediction Workflow

1. **Open Browser:** http://localhost:5000/prediction
2. **Upload Image:** Select any food image (supported: JPG, PNG, GIF, WebP)
3. **System Will:**
   - Send image to Flask API (port 8000)
   - Get prediction (class, confidence, freshness)
   - Save prediction to database with all details
   - Display results on prediction page
4. **View Dashboard:** http://localhost:5000/dashboard
   - Shows all predictions
   - Statistics and charts
5. **View Records:** http://localhost:5000/records
   - All prediction records in table format

## Troubleshooting

### Error: "Unknown column 'predicted_class' in 'field list'"
**Solution:** Run Option B above to add missing columns

### Error: "Cannot connect to database"
**Solution:** 
- Verify MySQL is running
- Check credentials in .env file
- Run `mysql -u root -p` and test connection

### Error: "Cannot connect to Flask API"
**Solution:**
- Ensure Flask server is running on port 8000
- Check if model.h5 exists in `artifacts/` folder
- Check Flask logs for model loading errors

### Error: "No file uploaded"
**Solution:**
- Make sure you selected a valid image file
- Check file size is under 10MB
- Verify file format is JPG, PNG, GIF, or WebP

### Images not showing in Dashboard
**Solution:**
- Images are stored in `Backend/uploads/` folder
- Make sure backend/public and backend/uploads are accessible
- Check if paths in views are correct

## File Structure After Fix

```
Backend/
├── index.js (Main server - handles prediction flow)
├── package.json
├── uploads/ (Saved prediction images go here)
├── public/
│   └── styles.css
└── views/
    ├── prediction.ejs (Upload and prediction page)
    ├── dashboard.ejs (View all predictions with stats)
    ├── records.ejs (All records in table)
    └── home.ejs

app.py (Flask API - runs model predictions)
requirements.txt (Python dependencies)
artifacts/
├── model.h5 (Trained TensorFlow model)
└── test/ (Test images for reference)

database_setup.sql (Initial database setup)
database_migration.sql (Add missing columns)
```

## Complete Workflow Summary

```
User Interface (Port 5000)
    ↓
Upload Image
    ↓
Node.js Server (Backend/index.js)
    ↓
Send to Flask API (Port 8000)
    ↓
Flask API (app.py)
    ↓
Load Model & Predict
    ↓
Return Prediction + Confidence
    ↓
Node.js Saves to Database
    ↓
Display Result on Prediction Page
    ↓
View in Dashboard & Records
```

## Quick Test

After setup, test with this command:

```bash
# Test Flask API
curl -X GET http://localhost:8000/api/health

# Test Node.js API
curl -X GET http://localhost:5000/api/stats

# Expected response:
# {"success":true,"stats":{...}}
```

## Still Having Issues?

1. Check logs in both terminals
2. Verify all 3 services are running:
   - MySQL (database)
   - Flask API (port 8000)
   - Node.js (port 5000)
3. Ensure model.h5 exists in artifacts/
4. Check if images folder has write permissions
