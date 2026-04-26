#!/usr/bin/env pwsh
# ================================================
# Food Freshness Classification - Quick Start
# ================================================
# Run this script to start both servers

Write-Host "================================" -ForegroundColor Cyan
Write-Host "🍎 Food Freshness Classifier" -ForegroundColor Green
Write-Host "Quick Start Script" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if Node.js is installed
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js is not installed. Please install Node.js first." -ForegroundColor Red
    exit 1
}

# Check if Python is installed
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Python is not installed. Please install Python first." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Node.js found: $(node --version)" -ForegroundColor Green
Write-Host "✅ Python found: $(python --version)" -ForegroundColor Green
Write-Host ""

# Navigate to Backend folder
$backendPath = Join-Path $PSScriptRoot "Backend"
if (-not (Test-Path $backendPath)) {
    Write-Host "❌ Backend folder not found!" -ForegroundColor Red
    exit 1
}

Write-Host "📦 Installing Node dependencies..." -ForegroundColor Yellow
Push-Location $backendPath
npm install form-data
npm install
Pop-Location

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Starting servers..." -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Create two new PowerShell windows for servers
Write-Host "Starting Flask API on port 8000..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot'; python app.py"

Start-Sleep -Seconds 3

Write-Host "Starting Node.js server on port 3000..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backendPath'; npm start"

Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "✅ Both servers are starting!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "📱 Flask API:  http://localhost:8000" -ForegroundColor Cyan
Write-Host "🌐 Web Server: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Open http://localhost:3000 in your browser to start!" -ForegroundColor Yellow
Write-Host ""
