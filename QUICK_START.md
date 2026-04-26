# 🚀 Quick Start Guide

## Start Here in 5 Minutes!

### Prerequisites Check
```bash
python --version  # Should be 3.8 or higher
node --version    # Should be 14 or higher
npm --version     # Should be 6 or higher
mysql --version   # Ensure MySQL is installed
```

### Step 1: Install Python Dependencies

```bash
# Navigate to project root
cd "Food freshness classification from visual features"

# Create virtual environment
python -m venv venv

# Activate virtual environment
venv\Scripts\activate  # Windows
# OR
source venv/bin/activate  # macOS/Linux

# Install dependencies
pip install -r requirements.txt
```

### Step 2: Setup Database

```sql
-- Open MySQL and run:
CREATE DATABASE food_db;
```

### Step 3: Configure Backend

```bash
cd Backend

# Create .env file
copy .env.example .env
# Edit .env with your MySQL password
```

### Step 4: Install Node Dependencies

```bash
# In Backend directory
npm install
```

### Step 5: Start the Application

**Terminal 1 - Start Flask API:**
```bash
# From project root
python app.py
```

**Terminal 2 - Start Node.js Server:**
```bash
# From Backend directory
cd Backend
npm start
```

### Step 6: Access the Application

- **Web Interface**: http://localhost:3000
- **API Documentation**: http://localhost:8000
- **Make a Prediction**: Go to http://localhost:3000/prediction

## File Upload Examples

Supported formats: JPEG, PNG, GIF, WebP (Max 10MB)

## Useful Commands

```bash
# Virtual Environment
deactivate                    # Deactivate Python environment

# Backend
npm run dev                   # Start with auto-reload
npm start                     # Production start

# Logs
tail -f logs/app.log         # View Flask logs in real-time
```

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| `Module not found` | Run `pip install -r requirements.txt` |
| `Port already in use` | Change port in `.env` files |
| `MySQL connection error` | Check database credentials in `.env` |
| `Model not found` | Train the model or ensure artifacts/model.h5 exists |

## Project URLs

| Service | URL | Purpose |
|---------|-----|---------|
| Frontend | http://localhost:3000 | Web interface |
| API | http://localhost:8000 | REST API |
| Dashboard | http://localhost:3000/dashboard | Analytics |
| Records | http://localhost:3000/records | Prediction history |

## Next Steps

1. ✅ Start the application
2. 📸 Upload an image to test predictions
3. 📊 View dashboard for analytics
4. 🔧 Customize model or add new features
5. 📚 Read full README.md for advanced configuration

---

**Need Help?** Check README.md or review logs in `logs/` directory.
