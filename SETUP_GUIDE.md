# 🍎 Food Freshness Classification - Complete Setup Guide

## ✅ STEP 1: Install Dependencies

```bash
cd Backend
npm install form-data
npm install
```

## ✅ STEP 2: Create MySQL Database

Open MySQL command line and run:

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS food_db;
USE food_db;

-- Create results table with all required columns
CREATE TABLE IF NOT EXISTS results (
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

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Verify the table
SELECT * FROM results LIMIT 0;
```

## ✅ STEP 3: Create .env File

Create a file named `.env` in the Backend folder:

```
PORT=3000
NODE_ENV=development
FLASK_API_URL=http://localhost:8000

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=shrinath1814
DB_NAME=food_db
```

## ✅ STEP 4: Start Flask API (First Terminal)

```bash
cd d:\e\ drive\Only_Project\Food\ freshness\ classification\ from\ visual\ features
python app.py
```

Expected output:
```
 * Running on http://127.0.0.1:8000
 * Press CTRL+C to quit
```

## ✅ STEP 5: Start Node.js Server (Second Terminal)

```bash
cd Backend
npm start
```

Expected output:
```
✓ Database connected successfully
✓ Database tables ready
╔═══════════════════════════════════════════════════════╗
║     🍎 Food Freshness Classification System 🍎       ║
║                  NODE.JS SERVER                       ║
║                                                       ║
║  Server running on: http://localhost:3000            ║
║  Status: ✓ Connected                                 ║
╚═══════════════════════════════════════════════════════╝
```

## ✅ STEP 6: Test the System

1. Open browser: http://localhost:3000
2. Click **Predict**
3. Upload an image
4. Wait for prediction
5. Check **Dashboard** for results

## 🔧 Troubleshooting

### Error: "Unknown column 'predicted_class'"
- **Solution**: Run the SQL commands above to create the table properly

### Error: "Failed to load records"
- **Solution**: Same as above - table doesn't exist or is incomplete

### Prediction stuck on "Processing..."
- **Solution**: Check if Flask API is running on port 8000
- Run: `python app.py`

### Error: "Connection refused" to Flask
- **Solution**: Make sure Flask API is running in another terminal
- Check: http://localhost:8000 (should show API info)

### Port already in use
- **Solution**: Change PORT in .env file or kill the process using that port
- PowerShell: `Get-Process -Id (Get-NetTCPConnection -LocalPort 3000).OwningProcess | Stop-Process`

## 📊 Expected Data Flow

```
User Upload Image
       ↓
Node.js /predict route
       ↓
Flask API /api/predict
       ↓
Get prediction (class, confidence)
       ↓
Save to MySQL database
       ↓
Dashboard displays data
       ↓
Charts and statistics update
```

## ✨ Features Working

✅ Image upload with drag & drop
✅ Real-time preview
✅ Flask API prediction
✅ Database storage
✅ Dashboard with statistics
✅ Charts (Fresh vs Rotten, Product Distribution, Confidence Scores)
✅ Records page with filtering
✅ Professional navbar on all pages

---

**If you still see errors, provide the screenshot and I'll debug further!**
