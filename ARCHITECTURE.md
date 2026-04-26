# 🏗️ System Architecture & Data Flow

## Complete System Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                           USER BROWSER                              │
│                   http://localhost:3000/prediction                  │
│                                                                     │
│  ┌───────────────────────────────────────────────────────────┐     │
│  │                    Upload UI (prediction.ejs)            │     │
│  │                                                          │     │
│  │  1. Select Image → 2. Click Predict                     │     │
│  │  3. See Loading Spinner                                 │     │
│  │  4. Results appear (NO RELOAD!)                         │     │
│  └───────────────────────────────────────────────────────────┘     │
│                              ↓                                      │
│                    JavaScript Fetch API                             │
│                         POST /predict                               │
└─────────────────────────────────────────────────────────────────────┘
                               ↓↑
                           HTTP Port 3000
                               ↓↑
┌─────────────────────────────────────────────────────────────────────┐
│                    NODE.JS BACKEND SERVER                           │
│                    (Backend/index.js)                              │
│                   http://localhost:3000                             │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────┐       │
│  │  Receives Image Upload (FormData)                      │       │
│  │  ✓ Validates file format & size                        │       │
│  │  ✓ Stores temporarily                                  │       │
│  └─────────────────────────────────────────────────────────┘       │
│                              ↓                                      │
│  ┌─────────────────────────────────────────────────────────┐       │
│  │  Create FormData                                        │       │
│  │  Call Flask API: POST http://localhost:8000/api/predict│       │
│  └─────────────────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────────────┘
                               ↓↑
                           HTTP Port 8000
                               ↓↑
┌─────────────────────────────────────────────────────────────────────┐
│                    FLASK API (PREDICTION ENGINE)                    │
│                          (app.py)                                  │
│                   http://localhost:8000                             │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────┐       │
│  │  Receive Image                                          │       │
│  │  Load Model: artifacts/model.h5                         │       │
│  │  Preprocess Image → 224x224 pixels                     │       │
│  │  Run Through TensorFlow CNN Model                      │       │
│  └─────────────────────────────────────────────────────────┘       │
│                              ↓                                      │
│  ┌─────────────────────────────────────────────────────────┐       │
│  │  Generate Prediction                                    │       │
│  │  ✓ class: "freshapples"                                │       │
│  │  ✓ confidence: 0.95                                    │       │
│  │  ✓ product: "Apples"                                   │       │
│  │  ✓ freshness: "Fresh"                                  │       │
│  │                                                         │       │
│  │  Return JSON Response                                   │       │
│  └─────────────────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────────────┘
                               ↓↑
                      JSON Response (Port 8000)
                               ↓↑
┌─────────────────────────────────────────────────────────────────────┐
│                    NODE.JS BACKEND (continued)                      │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────┐       │
│  │  Receive Prediction from Flask                         │       │
│  │  ✓ Parse JSON response                                 │       │
│  │  ✓ Create INSERT query                                 │       │
│  └─────────────────────────────────────────────────────────┘       │
│                              ↓                                      │
│  ┌─────────────────────────────────────────────────────────┐       │
│  │  Save to Database (MySQL)                              │       │
│  │  INSERT INTO results (                                 │       │
│  │    image, result, predicted_class,                     │       │
│  │    confidence, product_name, freshness                 │       │
│  │  )                                                      │       │
│  └─────────────────────────────────────────────────────────┘       │
│                              ↓↓ (Parallel)                          │
│           ┌──────────────────┴──────────────────┐                  │
│           ↓                                      ↓                  │
│    Database (MySQL)                    Return JSON to Browser      │
│    Connection Established           {"success": true,             │
│    Query Executed                     "prediction": {...}}        │
│    Row Inserted with ID 1             Status: 200 OK              │
│    ✓ All fields saved                 Port: 3000                  │
└─────────────────────────────────────────────────────────────────────┘
                               ↓↑
                    JSON Response (Port 3000)
                               ↓↑
┌─────────────────────────────────────────────────────────────────────┐
│                         BROWSER (JavaScript)                         │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────┐       │
│  │  Receive JSON Response                                  │       │
│  │  ✓ Parse prediction data                               │       │
│  │  ✓ Call displayResult(prediction)                      │       │
│  │  ✓ Update DOM with results                             │       │
│  │  ✓ Hide loading spinner                                │       │
│  │  ✓ Show results section                                │       │
│  │                                                         │       │
│  │  Results Displayed:                                     │       │
│  │  ✓ Product: Apples                                     │       │
│  │  ✓ Classification: FRESH APPLES                        │       │
│  │  ✓ Confidence: 95%                                     │       │
│  │  ✓ Status: ✓ Fresh                                     │       │
│  │                                                         │       │
│  │  ✅ NO PAGE RELOAD - Results on same page!             │       │
│  └─────────────────────────────────────────────────────────┘       │
│                              ↓                                      │
│  ┌─────────────────────────────────────────────────────────┐       │
│  │  User navigates to Dashboard                           │       │
│  │  GET http://localhost:3000/dashboard                   │       │
│  └─────────────────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────────────┘
                               ↓↑
                    HTTP Request/Response
                               ↓↑
┌─────────────────────────────────────────────────────────────────────┐
│                    NODE.JS DASHBOARD ROUTE                          │
│                      (Backend/index.js)                             │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────┐       │
│  │  app.get("/dashboard", ...)                            │       │
│  │  1. Query MySQL: SELECT * FROM results                 │       │
│  │  2. Calculate statistics                               │       │
│  │     - Total predictions                                │       │
│  │     - Fresh vs Rotten count                            │       │
│  │     - Average confidence                               │       │
│  │  3. Render dashboard.ejs with data                     │       │
│  │  4. Send HTML to browser                               │       │
│  └─────────────────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────────────┘
                               ↓↑
                         HTML Response
                               ↓↑
┌─────────────────────────────────────────────────────────────────────┐
│                    DASHBOARD PAGE (Browser)                         │
│                                                                     │
│  ✅ Shows all predictions in a table                               │
│  ✅ Shows statistics (Total, Fresh, Rotten, etc.)                 │
│  ✅ Latest prediction visible immediately                          │
│  ✅ Charts and visualizations                                      │
│  ✅ User sees complete flow working!                               │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Database Schema

```
┌──────────────────────────────────────┐
│             MySQL Database            │
│         (food_db / results table)     │
└──────────────────────────────────────┘
           ↓
┌──────────────────────────────────────────────────────────┐
│  Column Name      │ Type          │ Stored Data          │
├──────────────────────────────────────────────────────────┤
│ id               │ INT           │ 1, 2, 3, ... (Auto)  │
│ image            │ VARCHAR(255)  │ path/to/image.jpg    │
│ result           │ LONGTEXT      │ Full JSON prediction │
│ predicted_class  │ VARCHAR(50)   │ freshapples          │
│ confidence       │ FLOAT         │ 0.95                 │
│ product_name     │ VARCHAR(100)  │ Apples               │
│ freshness        │ VARCHAR(20)   │ Fresh / Rotten       │
│ created_at       │ TIMESTAMP     │ 2024-01-15 10:30:45  │
└──────────────────────────────────────────────────────────┘
           ↓
┌──────────────────────────────────────┐
│     Indexed for Fast Queries          │
│  - created_at (Sorting)               │
│  - predicted_class (Filtering)        │
│  - freshness (Filtering)              │
└──────────────────────────────────────┘
```

---

## Prediction Flow Timeline

```
Time    Event                                  Status
────    ─────────────────────────────────────  ──────────────
0s      User selects image                    ✓ Ready
        
1s      User clicks "Predict"                 ✓ Starting...
        
2s      Form submits (Fetch API)              ⏳ Uploading
        Loading spinner appears
        
3s      Node.js receives image                ⏳ Processing
        Sends to Flask API
        
4s      Flask loads model                     ⏳ Analyzing
        
5s      Flask predicts class                  ⏳ Predicting
        
6s      Flask returns JSON                    ✓ Prediction done
        
7s      Node.js receives prediction           ⏳ Saving
        Saves to database
        
8s      Node.js returns JSON                  ✓ Response sent
        
9s      Browser receives JSON                 ⏳ Rendering
        displayResult() called
        
10s     Results appear on screen              ✅ COMPLETE!
        No page reload!
        
11s+    User views in dashboard               ✅ Data visible
        Checks database records
        
────────────────────────────────────────────────
Total time: ~10 seconds (with visual feedback)
```

---

## Port Configuration

```
┌─────────────────────────────────────────┐
│         Service Ports in Use            │
├─────────────────────────────────────────┤
│ Node.js Backend    │ 3000 (or 5000)     │
│ Flask API          │ 8000               │
│ MySQL              │ 3306 (default)     │
│ Browser localhost  │ 5000 (Windows)     │
│ Browser localhost  │ 3000 (After fix)   │
└─────────────────────────────────────────┘
```

---

## File Structure

```
Food freshness classification from visual features/
│
├── app.py ────────────────────── Flask API (Port 8000)
├── requirements.txt ─────────── Python dependencies
│
├── Backend/ ─────────────────── Node.js Server (Port 3000)
│   ├── index.js ──────────────── Main server & routes
│   ├── package.json ─────────── Node dependencies
│   ├── .env ───────────────── Configuration
│   ├── uploads/ ───────────── Saved images
│   └── views/ ────────────────── EJS templates
│       ├── prediction.ejs ──── Upload page (FIXED!)
│       ├── dashboard.ejs ───── Dashboard
│       ├── records.ejs ──────── Records
│       └── analytics.ejs ────── Analytics
│
├── artifacts/
│   ├── model.h5 ────────────── TensorFlow model
│   └── test/ ───────────────── Test images
│
└── src/ ──────────────────────── Python source
    ├── Pipeline/
    │   └── predict_pipeline.py ── Prediction logic
    └── Components/
        └── model_trainer.py ──── Model training
```

---

## What Happens When You Upload

```
Step 1: Browser
┌─────────────────────────────────┐
│ User selects file               │
│ Shows preview                   │
│ Clicks "Predict"               │
│ FormData created               │
└─────────────────────────────────┘
          ↓

Step 2: JavaScript Fetch
┌─────────────────────────────────┐
│ POST http://localhost:3000/predict
│ Headers: multipart/form-data    │
│ Body: image file (FormData)     │
│ Hide upload, show spinner       │
└─────────────────────────────────┘
          ↓

Step 3: Node.js Handler
┌─────────────────────────────────┐
│ Receive multipart upload        │
│ Validate file (type, size)      │
│ Create FormData for Flask       │
│ POST to Flask API               │
│ Wait for prediction             │
└─────────────────────────────────┘
          ↓

Step 4: Flask Processing
┌─────────────────────────────────┐
│ Load model.h5                   │
│ Preprocess image                │
│ Make prediction                 │
│ Return JSON                     │
└─────────────────────────────────┘
          ↓

Step 5: Node.js Response
┌─────────────────────────────────┐
│ Receive prediction JSON         │
│ INSERT into MySQL database      │
│ Return success to browser       │
│ Include prediction data         │
└─────────────────────────────────┘
          ↓

Step 6: Browser Display
┌─────────────────────────────────┐
│ Parse JSON response             │
│ Hide loading spinner            │
│ Show result section             │
│ Display: Product, Class,        │
│          Confidence, Status     │
│ NO PAGE RELOAD!                 │
└─────────────────────────────────┘
          ↓

Step 7: Database
┌─────────────────────────────────┐
│ Row inserted in results table   │
│ All fields saved: class,        │
│ confidence, product, freshness  │
│ Timestamp recorded              │
│ Available for dashboard         │
└─────────────────────────────────┘
```

---

## Success Criteria

```
✅ Prediction Works When:
  1. Upload page loads
  2. Can select image
  3. Spinner appears on predict
  4. Results show (no reload!)
  5. Data in dashboard
  6. Data in database
  7. No errors in console

❌ Prediction Fails If:
  1. Flask not running
  2. Node not running
  3. Database not connected
  4. Model file missing
  5. Port already in use
```

---

## System Health Check

```
Component          Status Check                Expected Result
──────────────────────────────────────────────────────────────
Flask API          curl localhost:8000/api     {"status":"success"}
                   /health                     

Node.js Server     curl localhost:3000/api     {"success":true,
                   /stats                      "stats":{...}}

MySQL Database     mysql -u root -p            mysql> (prompt)
                   food_db                     

Prediction Page    http://localhost:3000/      Upload page loads
                   prediction                  

Model File         Check artifacts/model.h5   File exists
                                               ~150MB

Upload Folder      ls Backend/uploads/         Empty initially
```

---

**Complete system ready! 🚀**
