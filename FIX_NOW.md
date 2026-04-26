# ⚠️ IMPORTANT - FIX YOUR SYSTEM IN 5 MINUTES

## Current Issues:
Your system shows errors because **the database table doesn't exist yet**. This is fixable in 5 minutes!

## 3-Step Fix:

### STEP 1️⃣: Create Database (1 min)
Open MySQL and run the commands in `init-database.sql`:
```sql
CREATE DATABASE food_db;
USE food_db;

CREATE TABLE results (
  id INT AUTO_INCREMENT PRIMARY KEY,
  image VARCHAR(255) NOT NULL,
  result LONGTEXT NOT NULL,
  predicted_class VARCHAR(50),
  confidence FLOAT,
  product_name VARCHAR(100),
  freshness VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_created (created_at),
  INDEX idx_class (predicted_class),
  INDEX idx_freshness (freshness)
);

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL,
  email VARCHAR(100),
  password VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### STEP 2️⃣: Start Flask API (1 min)
```bash
cd "d:\e drive\Only_Project\Food freshness classification from visual features"
python app.py
```
Wait for: `Running on http://127.0.0.1:8000` ✓

### STEP 3️⃣: Start Node.js Server (1 min)
```bash
cd "d:\e drive\Only_Project\Food freshness classification from visual features\Backend"
npm install form-data
npm start
```
Wait for: `✓ Server running on: http://localhost:3000` ✓

## 🎯 Test It:
1. Go to: http://localhost:3000/prediction
2. Upload any image
3. Click "Classify Image"
4. Check Dashboard - you should see your prediction! ✅

## 📚 Read These Files For Details:
- `QUICK_START.md` - Quick setup
- `SETUP_GUIDE.md` - Detailed setup  
- `DIAGNOSTIC.md` - Troubleshooting

---

**That's it! The system will work after these 3 steps.** 🎉
