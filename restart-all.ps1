#!/usr/bin/env pwsh
# Complete restart script for Food Freshness System

Write-Host "🔄 Restarting Food Freshness Classification System..." -ForegroundColor Cyan
Write-Host ""

# Kill any existing Node.js processes
Write-Host "Stopping existing Node.js servers..." -ForegroundColor Yellow
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 1

Write-Host "✓ Processes cleaned" -ForegroundColor Green
Write-Host ""

# Start Flask API
Write-Host "🚀 Starting Flask API on port 8000..." -ForegroundColor Cyan
$flaskProcess = Start-Process python -ArgumentList "app.py" -PassThru -NoNewWindow -WorkingDirectory (Get-Location)
Write-Host "Flask process ID: $($flaskProcess.Id)" -ForegroundColor Green
Start-Sleep -Seconds 3

# Start Node.js Server
Write-Host ""
Write-Host "🚀 Starting Node.js Server on port 3000..." -ForegroundColor Cyan
$nodeProcess = Start-Process npm -ArgumentList "start" -PassThru -NoNewWindow -WorkingDirectory "Backend"
Write-Host "Node.js process ID: $($nodeProcess.Id)" -ForegroundColor Green
Start-Sleep -Seconds 3

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✓ All Services Started Successfully!                 ║" -ForegroundColor Green
Write-Host "╠════════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "║  📍 Frontend: http://localhost:3000                    ║" -ForegroundColor Green
Write-Host "║  📍 Upload: http://localhost:3000/prediction           ║" -ForegroundColor Green
Write-Host "║  📍 Dashboard: http://localhost:3000/dashboard         ║" -ForegroundColor Green
Write-Host "║  📍 Records: http://localhost:3000/records             ║" -ForegroundColor Green
Write-Host "║  📍 Flask API: http://localhost:8000                   ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Opening dashboard in browser..." -ForegroundColor Cyan
Start-Sleep -Seconds 2

# Try to open in browser
try {
    Start-Process "http://localhost:3000/prediction"
} catch {
    Write-Host "Please open http://localhost:3000/prediction in your browser" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✓ System ready for predictions!" -ForegroundColor Green
