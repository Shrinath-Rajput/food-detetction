# 🔧 System Diagnostic & Fix Script

## Diagnose Issues

### ✅ Check 1: Verify MySQL is Running
```bash
# Check if MySQL process is running
Get-Process mysqld -ErrorAction SilentlyContinue

# If not running, start MySQL:
# On Windows: Use MySQL Workbench or Services
# Or run: mysqld --install-manual MySQL80
#         net start MySQL80
```

### ✅ Check 2: Verify Database Exists
```bash
# Connect to MySQL
mysql -u root -p

# Then in MySQL console:
SHOW DATABASES;
USE food_db;
SHOW TABLES;
DESCRIBE results;
```

### ✅ Check 3: Fix Database Issues

Run the SQL file:
```bash
mysql -u root -pshrinath1814 < init-database.sql
```

Or manually in MySQL:
```sql
-- Drop and recreate database
DROP DATABASE IF EXISTS food_db;
CREATE DATABASE food_db;
USE food_db;

-- Create table
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
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Verify
SHOW TABLES;
DESCRIBE results;
```

### ✅ Check 4: Check Ports
```bash
# Check if port 3000 is in use
Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue

# Check if port 8000 is in use  
Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue

# Kill process using port 3000 (if needed):
Get-Process -Id (Get-NetTCPConnection -LocalPort 3000).OwningProcess | Stop-Process -Force

# Kill process using port 8000 (if needed):
Get-Process -Id (Get-NetTCPConnection -LocalPort 8000).OwningProcess | Stop-Process -Force
```

### ✅ Check 5: Test Flask API
```bash
# Open browser and go to:
http://localhost:8000

# Should show JSON with API info
# If error: Flask is not running
# Solution: python app.py
```

### ✅ Check 6: Test Node.js Server
```bash
# Open browser and go to:
http://localhost:3000

# Should show home page
# If error: Node.js is not running
# Solution: cd Backend && npm start
```

## Complete Startup Sequence

### Terminal 1 - Flask API
```bash
# Make sure you're in the project root directory
cd "d:\e drive\Only_Project\Food freshness classification from visual features"
python app.py
```
Wait for: `Running on http://127.0.0.1:8000`

### Terminal 2 - Node.js Backend
```bash
cd "d:\e drive\Only_Project\Food freshness classification from visual features\Backend"
npm start
```
Wait for: ASCII banner with connection info

### Terminal 3 - MySQL (if not running)
```bash
mysql -u root -p
# Enter password: shrinath1814

# Then verify database:
USE food_db;
SHOW TABLES;
SELECT * FROM results;
```

## Test the Application

1. Open: http://localhost:3000
2. Go to Predict
3. Upload an image
4. Click "Classify Image"
5. Wait for result
6. Go to Dashboard - should see your prediction
7. Check Records - should see your prediction
8. Check MySQL:
```sql
SELECT * FROM results ORDER BY created_at DESC LIMIT 1;
```

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Port 3000 already in use | Kill: `Get-Process node \| Stop-Process` |
| Port 8000 already in use | Kill: `Get-Process python \| Stop-Process` |
| Database error | Run: `mysql -u root -pshrinath1814 < init-database.sql` |
| Table doesn't exist | Create manually using SQL above |
| Prediction stuck | Check if Flask API is running on port 8000 |
| Dashboard shows error | Check if MySQL database exists: `mysql -u root -p` then `SHOW DATABASES;` |

---

**Need help? Check the SETUP_GUIDE.md file for detailed instructions!**
