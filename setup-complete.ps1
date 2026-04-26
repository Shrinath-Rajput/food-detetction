#!/usr/bin/env pwsh
<#
.SYNOPSIS
Complete setup and start script for Food Freshness Classification System
.DESCRIPTION
Fixes database, sets up all services, and starts the application
#>

# Color output
$Success = "Green"
$Error = "Red"
$Warning = "Yellow"
$Info = "Cyan"

function Write-Success { Write-Host $args -ForegroundColor $Success }
function Write-Error2 { Write-Host $args -ForegroundColor $Error }
function Write-Warning2 { Write-Host $args -ForegroundColor $Warning }
function Write-Info { Write-Host $args -ForegroundColor $Info }

Clear-Host

Write-Info "╔════════════════════════════════════════════════════════╗"
Write-Info "║  🍎 Food Freshness Classification System Setup 🍎    ║"
Write-Info "╠════════════════════════════════════════════════════════╣"
Write-Info "║  This script will:                                     ║"
Write-Info "║  1. Check all dependencies                             ║"
Write-Info "║  2. Set up database with proper schema                 ║"
Write-Info "║  3. Start Flask API (Port 8000)                        ║"
Write-Info "║  4. Start Node.js Server (Port 5000)                   ║"
Write-Info "║  5. Open dashboard in browser                          ║"
Write-Info "╚════════════════════════════════════════════════════════╝"
Write-Host ""

# Check prerequisites
Write-Info "Checking prerequisites..."

$missingTools = @()

try { python --version | Out-Null } catch { $missingTools += "Python" }
try { node --version | Out-Null } catch { $missingTools += "Node.js" }
try { npm --version | Out-Null } catch { $missingTools += "npm" }
try { mysql --version | Out-Null } catch { $missingTools += "MySQL" }

if ($missingTools.Count -gt 0) {
    Write-Error2 "❌ Missing tools: $($missingTools -join ', ')"
    Write-Error2 "Please install them first and try again."
    exit 1
}

Write-Success "✓ All prerequisites installed"
Write-Host ""

# Check if model exists
Write-Info "Checking model files..."
if (-not (Test-Path "artifacts/model.h5")) {
    Write-Error2 "❌ Model file not found: artifacts/model.h5"
    Write-Error2 "Please ensure the trained model is in the artifacts folder"
    exit 1
}
Write-Success "✓ Model file found"

# Check database
Write-Info "Checking MySQL connection..."
$mysqlCheck = mysql -u root -pshrinath1814 -e "SELECT 'Connection OK'" 2>&1
if ($mysqlCheck -like "*Connection OK*") {
    Write-Success "✓ MySQL connection successful"
} else {
    Write-Warning2 "⚠️ MySQL connection failed"
    Write-Info "Ensure MySQL is running and credentials are correct"
}

Write-Host ""
Write-Info "Applying database fixes..."

# Run database migration
$dbMigration = @"
USE mysql;
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
"@

$dbMigration | mysql -u root -pshrinath1814 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Success "✓ Database schema created/updated successfully"
} else {
    Write-Warning2 "⚠️ Database setup had some issues but continuing..."
}

Write-Host ""
Write-Info "Installing dependencies..."

# Install Python dependencies
if (Test-Path "requirements.txt") {
    Write-Info "Installing Python packages..."
    python -m pip install -q -r requirements.txt 2>&1 | Out-Null
    Write-Success "✓ Python dependencies installed"
}

# Install Node dependencies
if (Test-Path "Backend/package.json") {
    Write-Info "Installing Node packages..."
    Push-Location Backend
    npm install --quiet 2>&1 | Out-Null
    Pop-Location
    Write-Success "✓ Node dependencies installed"
}

Write-Host ""
Write-Success "╔════════════════════════════════════════════════════════╗"
Write-Success "║  ✓ Setup Complete! Ready to start services            ║"
Write-Success "╚════════════════════════════════════════════════════════╝"
Write-Host ""

Write-Info "Starting services..."
Write-Info "Opening 2 new terminal windows..."
Write-Host ""

# Start Flask API in new terminal
Write-Info "→ Flask API will start on http://localhost:8000"
$flaskScript = @"
`$OriginalLocation = Get-Location
cd '$PWD'
Write-Host '🚀 Starting Flask API...'
python app.py
Read-Host 'Press Enter to close'
"@

$flaskScript | Out-File -FilePath "$env:TEMP\start-flask.ps1" -Encoding UTF8
Start-Process powershell -ArgumentList "-NoExit -ExecutionPolicy Bypass -File `"$env:TEMP\start-flask.ps1`""

Start-Sleep -Seconds 3

# Start Node.js Server in new terminal
Write-Info "→ Node.js Server will start on http://localhost:5000"
$nodeScript = @"
`$OriginalLocation = Get-Location
cd '$PWD\Backend'
Write-Host '🚀 Starting Node.js Server...'
npm start
Read-Host 'Press Enter to close'
"@

$nodeScript | Out-File -FilePath "$env:TEMP\start-node.ps1" -Encoding UTF8
Start-Process powershell -ArgumentList "-NoExit -ExecutionPolicy Bypass -File `"$env:TEMP\start-node.ps1`""

Write-Host ""
Write-Success "╔════════════════════════════════════════════════════════╗"
Write-Success "║  Services Starting...                                  ║"
Write-Success "╚════════════════════════════════════════════════════════╝"
Write-Host ""

Write-Info "Waiting 5 seconds for services to start..."
Start-Sleep -Seconds 5

Write-Info "Opening dashboard..."
Start-Sleep -Seconds 2

# Open browser
$browsers = @("chrome", "msedge", "firefox")
$opened = $false

foreach ($browser in $browsers) {
    try {
        Start-Process $browser "http://localhost:5000/dashboard" -ErrorAction Stop
        $opened = $true
        break
    } catch {
        # Browser not found, try next
    }
}

if (-not $opened) {
    Write-Warning2 "Please open http://localhost:5000/dashboard in your browser"
}

Write-Host ""
Write-Success "╔════════════════════════════════════════════════════════╗"
Write-Success "║  🎉 System Ready!                                      ║"
Write-Success "╠════════════════════════════════════════════════════════╣"
Write-Success "║  📍 Frontend: http://localhost:5000                    ║"
Write-Success "║  📍 Flask API: http://localhost:8000                   ║"
Write-Success "║  📍 Dashboard: http://localhost:5000/dashboard         ║"
Write-Success "║  📍 Predict: http://localhost:5000/prediction          ║"
Write-Success "║  📍 Records: http://localhost:5000/records             ║"
Write-Success "╚════════════════════════════════════════════════════════╝"
Write-Host ""
Write-Info "You can now upload images to make predictions!"
Write-Host ""
