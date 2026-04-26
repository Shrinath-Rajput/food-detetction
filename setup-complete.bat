@echo off
REM ================================================
REM Food Freshness Classification System Setup
REM ================================================

setlocal enabledelayedexpansion

cls
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║  🍎 Food Freshness Classification System Setup 🍎    ║
echo ╚════════════════════════════════════════════════════════╝
echo.

echo Checking prerequisites...
where python >nul 2>nul
if errorlevel 1 (
    echo ❌ Python not found. Please install Python.
    exit /b 1
)

where node >nul 2>nul
if errorlevel 1 (
    echo ❌ Node.js not found. Please install Node.js.
    exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
    echo ❌ npm not found. Please install npm.
    exit /b 1
)

echo ✓ All prerequisites installed
echo.

echo Setting up database...
mysql -u root -pshrinath1814 -e "DROP DATABASE IF EXISTS food_db; CREATE DATABASE food_db;" >nul 2>nul

mysql -u root -pshrinath1814 food_db << EOF
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
EOF

echo ✓ Database created
echo.

echo Installing dependencies...
call python -m pip install -q -r requirements.txt >nul 2>nul
echo ✓ Python packages installed

cd Backend
call npm install --quiet >nul 2>nul
echo ✓ Node packages installed
cd ..
echo.

echo ╔════════════════════════════════════════════════════════╗
echo ║  ✓ Setup Complete!                                    ║
echo ║  Now starting services...                              ║
echo ╚════════════════════════════════════════════════════════╝
echo.

REM Start Flask API in new window
echo Starting Flask API on port 8000...
start cmd /k "title Flask API & python app.py"

timeout /t 3 /nobreak

REM Start Node.js server in new window
echo Starting Node.js Server on port 5000...
cd Backend
start cmd /k "title Node.js Server & npm start"
cd ..

echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║  Services Starting...                                  ║
echo ║  Opening Dashboard in 5 seconds...                     ║
echo ╚════════════════════════════════════════════════════════╝
echo.

timeout /t 5 /nobreak

REM Open in default browser
start http://localhost:5000/dashboard

echo.
echo ✓ System ready at http://localhost:5000
echo ✓ Flask API at http://localhost:8000
echo.
