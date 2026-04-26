# 🚀 COMPLETE SETUP GUIDE - Food Freshness Classification System

## ⚡ Quick Setup (5 minutes)

### Step 1: Run Database Setup
Run this in MySQL Workbench, MySQL Command Line, or any MySQL client:

```sql
DROP DATABASE IF EXISTS food_db;
CREATE DATABASE food_db;
USE food_db;

CREATE TABLE results (
  id INT AUTO_INCREMENT PRIMARY KEY,
  image VARCHAR(255) NOT NULL,
  result LONGTEXT NOT NULL,
  predicted_class VARCHAR(50) NOT NULL DEFAULT 'unknown',
  confidence FLOAT NOT NULL DEFAULT 0.0,
  product_name VARCHAR(100) NOT NULL DEFAULT 'unknown',
  freshness VARCHAR(20) NOT NULL DEFAULT 'unknown',
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

SHOW TABLES;
```

**Expected Output:**
```
Database created ✓
Tables: results, users ✓
```

### Step 2: Start Services

**Terminal 1 - Flask API (Port 8000):**
```bash
cd "Food freshness classification from visual features"
python app.py
```

Wait for message: `✓ Model loaded successfully`

**Terminal 2 - Node.js Server (Port 5000):**
```bash
cd "Food freshness classification from visual features\Backend"
npm install
npm start
```

Wait for message: `✓ Database connected successfully`

### Step 3: Access the System

Open your browser:
- **Main Dashboard:** http://localhost:5000/dashboard
- **Make Prediction:** http://localhost:5000/prediction
- **View Records:** http://localhost:5000/records
- **API Stats:** http://localhost:5000/api/stats

---

## 🎯 Complete Workflow

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Upload Food Image                                        │
│    http://localhost:5000/prediction                         │
└────────────────┬────────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────────┐
│ 2. Node.js Backend Receives Image                           │
│    - Validates file format & size                           │
│    - Sends to Flask API for prediction                      │
└────────────────┬────────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────────┐
│ 3. Flask API Predicts (Port 8000)                           │
│    - Loads TensorFlow model from artifacts/model.h5         │
│    - Analyzes image features                                │
│    - Returns: class, confidence, freshness status           │
└────────────────┬────────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────────┐
│ 4. Node.js Saves to Database                                │
│    - Stores image path in Backend/uploads/                  │
│    - Saves prediction results to MySQL                      │
│    - Records: predicted_class, confidence, freshness        │
└────────────────┬────────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────────────┐
│ 5. Display Results                                          │
│    - Shows prediction on prediction page                    │
│    - Updates dashboard in real-time                         │
│    - Stores record in database for history                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 Troubleshooting

### Issue 1: "Unknown column 'predicted_class' in 'field list'"

**Cause:** Database table doesn't have the required columns

**Fix:**
```sql
USE food_db;
-- Run the SQL above in Step 1
```

### Issue 2: "Cannot GET /dashboard" or "Cannot GET /prediction"

**Cause:** Node.js server not running properly

**Fix:**
```bash
cd "Food freshness classification from visual features\Backend"
npm install
npm start
```

### Issue 3: "Failed to load predictions" or "Connection Refused"

**Cause:** Database not connected

**Check:**
```bash
# Test MySQL connection
mysql -u root -pshrinath1814 -e "USE food_db; SHOW TABLES;"
```

**Output should show:**
```
+--------------------+
| Tables_in_food_db  |
+--------------------+
| results            |
| users              |
+--------------------+
```

### Issue 4: "Cannot connect to Flask API"

**Cause:** Flask server not running or model not loaded

**Fix:**
```bash
python app.py
```

**Check logs for:**
```
✓ Model loaded successfully
FOOD FRESHNESS CLASSIFICATION API
```

### Issue 5: Images not showing in dashboard

**Cause:** Images stored but paths incorrect

**Fix:**
- Images are stored in: `Backend/uploads/`
- Make sure Backend/public is served as static files
- Check Backend/index.js has `app.use(express.static("uploads"))`

### Issue 6: Upload button not working

**Cause:** File validation error

**Fix:**
- Supported formats: JPG, PNG, GIF, WebP
- Max file size: 10MB
- Check browser console for error messages

---

## 📊 Database Schema

### Results Table
```sql
+------------------+-------------+------+-----+---------+----------------+
| Field            | Type        | Null | Key | Default | Extra          |
+------------------+-------------+------+-----+---------+----------------+
| id               | int         | NO   | PRI | NULL    | auto_increment |
| image            | varchar(255)| NO   |     | NULL    |                |
| result           | longtext    | NO   |     | NULL    |                |
| predicted_class  | varchar(50) | NO   | MUL | unknown |                |
| confidence       | float       | NO   |     | 0       |                |
| product_name     | varchar(100)| NO   |     | unknown |                |
| freshness        | varchar(20) | NO   |     | unknown |                |
| created_at       | timestamp   | NO   | MUL | CURRENT |                |
+------------------+-------------+------+-----+---------+----------------+
```

### Sample Data
```sql
-- After making a prediction, check:
SELECT * FROM results;

-- Expected output:
-- id | image | result | predicted_class | confidence | product_name | freshness | created_at
-- 1  | path  | json   | freshapples     | 0.95       | Apples       | Fresh     | 2024-01-15...
```

---

## 🎨 Features & Pages

### 1. Prediction Page (`/prediction`)
- Upload food image
- Real-time prediction
- Shows confidence score
- Displays freshness status (Fresh/Rotten)
- Saves to database automatically

### 2. Dashboard (`/dashboard`)
- View all predictions with pagination
- Statistics: Total predictions, Fresh/Rotten counts
- Average confidence
- Product distribution chart
- Class distribution chart
- Sortable by date

### 3. Records (`/records`)
- Table view of all predictions
- Sortable columns
- Latest 50 records
- Quick view of all details

### 4. API Endpoints

**Stats Endpoint:**
```bash
curl http://localhost:5000/api/stats
```

**Response:**
```json
{
  "success": true,
  "stats": {
    "total_predictions": 5,
    "unique_classes": 3,
    "avg_confidence": 0.92
  },
  "classStats": [...]
}
```

**Predictions Endpoint:**
```bash
curl http://localhost:5000/api/predictions?limit=10
```

---

## 🤖 Classification Classes

### Fresh Products (9 classes)
- Fresh Apples
- Fresh Banana
- Fresh Bitter Gourd
- Fresh Capsicum
- Fresh Cucumber
- Fresh Okra
- Fresh Oranges
- Fresh Potato
- Fresh Tomato

### Rotten Products (8 classes)
- Rotten Apples
- Rotten Banana
- Rotten Bitter Gourd
- Rotten Capsicum
- Rotten Cucumber
- Rotten Okra
- Rotten Oranges
- Rotten Potato/Tomato

---

## 📁 Project Structure

```
Food freshness classification from visual features/
│
├── Backend/
│   ├── index.js (Main server - handles prediction flow)
│   ├── package.json (Node dependencies)
│   ├── .env (Database credentials - CONFIGURED)
│   ├── uploads/ (Saved prediction images)
│   ├── public/
│   │   └── styles.css (UI styles)
│   └── views/
│       ├── home.ejs
│       ├── prediction.ejs (Upload & predict)
│       ├── dashboard.ejs (Stats & visualization)
│       ├── records.ejs (Prediction history)
│       ├── analytics.ejs
│       ├── error.ejs
│       └── 404.ejs
│
├── app.py (Flask API - Prediction engine)
├── requirements.txt (Python dependencies)
│
├── src/
│   ├── Pipeline/
│   │   └── predict_pipeline.py (Model prediction logic)
│   ├── Components/
│   │   └── model_trainer.py
│   ├── exception.py
│   └── logger.py
│
├── artifacts/
│   ├── model.h5 (Trained TensorFlow model)
│   └── test/ (Sample test images)
│
├── database_setup.sql (Initial DB setup)
├── database_migration.sql (Add missing columns)
├── DATABASE_FIX.md (This file)
└── setup-complete.bat / setup-complete.ps1 (Automated setup)
```

---

## ✅ Verification Checklist

After setup, verify everything works:

- [ ] Database created with results table
- [ ] Flask API running on port 8000
- [ ] Node.js Server running on port 5000
- [ ] Can upload image on /prediction page
- [ ] Prediction appears immediately
- [ ] Dashboard shows the prediction
- [ ] Records page displays the entry
- [ ] API endpoint returns stats

---

## 🚀 Running the System

### Automated Setup (Recommended)

**Windows:**
```bash
.\setup-complete.bat
```

**PowerShell:**
```bash
powershell -ExecutionPolicy Bypass -File .\setup-complete.ps1
```

### Manual Setup

1. Run database SQL
2. Start Flask: `python app.py`
3. Start Node.js: `cd Backend && npm start`
4. Open http://localhost:5000/dashboard

---

## 📝 Environment Configuration

Your `.env` file is already configured with:
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=shrinath1814
DB_NAME=food_db
PORT=5000
FLASK_API_URL=http://localhost:8000
NODE_ENV=development
```

To change settings, edit `Backend/.env` and restart the server.

---

## 🆘 Emergency Fix

If everything breaks, run this:

```bash
# 1. Reset database
mysql -u root -pshrinath1814 < database_setup.sql

# 2. Clear uploads
rmdir /s Backend\uploads
mkdir Backend\uploads

# 3. Reinstall dependencies
pip install -r requirements.txt
cd Backend && npm install && cd ..

# 4. Start fresh
python app.py  # Terminal 1
cd Backend && npm start  # Terminal 2
```

---

## 📞 Getting Help

If you encounter issues:

1. Check the terminal logs for error messages
2. Verify all three services are running (MySQL, Flask, Node.js)
3. Check Backend/.env has correct credentials
4. Ensure port 5000 and 8000 are not in use
5. Clear browser cache and try again
6. Check if model.h5 exists in artifacts/

---

**System Status Dashboard:** http://localhost:5000
**API Documentation:** http://localhost:8000
