# 🚀 QUICK START - 3 STEPS TO RUNNING THE SYSTEM

## Step 1️⃣: Fix Database (One-time)
Run this in MySQL Workbench or `mysql` command line:

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## Step 2️⃣: Start Flask API (Terminal 1)
```bash
cd "Food freshness classification from visual features"
python app.py
```
✓ Wait for: `✓ Model loaded successfully`

## Step 3️⃣: Start Node.js Server (Terminal 2)
```bash
cd "Food freshness classification from visual features\Backend"
npm install
npm start
```
✓ Wait for: `✓ Database connected successfully`

## 🎯 Then Open:
**http://localhost:5000/prediction** - Upload & predict image

---

## 📊 What You Can Do:

| Page | URL | Function |
|------|-----|----------|
| **Upload** | http://localhost:5000/prediction | Upload image → See prediction |
| **Dashboard** | http://localhost:5000/dashboard | View stats & all predictions |
| **Records** | http://localhost:5000/records | See prediction history |
| **API** | http://localhost:5000/api/stats | Get statistics |

---

## 🐛 If It Doesn't Work:

| Error | Solution |
|-------|----------|
| "Unknown column 'predicted_class'" | Run the SQL from Step 1 |
| "Cannot connect to Flask API" | Make sure Terminal 1 is running `python app.py` |
| "Cannot GET /prediction" | Make sure Terminal 2 is running `npm start` |
| "Connection refused" | MySQL service must be running |

---

## ✅ Complete Workflow:

1. Upload image on http://localhost:5000/prediction
2. System predicts if food is Fresh or Rotten
3. Saves prediction to database
4. Shows result on screen
5. Updates dashboard automatically
6. View history on /records or /dashboard

**That's it! System ready to go! 🎉**
