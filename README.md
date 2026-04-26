# 🍎 Food Freshness Classification System

A professional AI-powered system to detect fresh and rotten produce using deep learning CNN models.

## 📋 Project Overview

This project combines:
- **Python Backend**: Flask API with TensorFlow/Keras for AI predictions
- **Node.js Server**: Express.js server with MySQL database for web interface
- **Professional UI**: Modern, responsive web dashboard with real-time analytics

## 🏗️ Project Structure

```
Food freshness classification from visual features/
├── app.py                          # Main Flask API
├── requirements.txt                # Python dependencies
├── .env.flask                      # Flask configuration
├── artifacts/
│   ├── train/                      # Training dataset
│   └── test/                       # Testing dataset
├── src/
│   ├── __init__.py
│   ├── exception.py               # Custom exception handling
│   ├── logger.py                  # Logging configuration
│   ├── utlis.py                   # Utility functions
│   ├── Components/
│   │   ├── data_ingestion.py      # Data loading
│   │   ├── data_transformation.py # Data preprocessing
│   │   └── model_trainer.py       # Model training
│   └── Pipeline/
│       ├── train_pipeline.py      # Training pipeline
│       └── predict_pipeline.py    # Prediction pipeline
├── dataset/
│   ├── Train/                     # Original training data
│   └── Test/                      # Original testing data
├── uploads/                        # Uploaded images
├── logs/                          # Application logs
└── Backend/
    ├── index.js                   # Main Node.js server
    ├── package.json               # Node.js dependencies
    ├── .env.example               # Environment variables example
    ├── views/
    │   ├── home.ejs              # Home page
    │   ├── prediction.ejs        # Prediction page
    │   ├── dashboard.ejs         # Analytics dashboard
    │   ├── records.ejs           # Prediction records
    │   ├── 404.ejs               # 404 error page
    │   └── error.ejs             # Error page
    ├── public/                    # Static files
    └── uploads/                   # Uploaded files
```

## 🚀 Getting Started

### Prerequisites

- Python 3.8+
- Node.js 14+
- MySQL 5.7+
- pip and npm

### Installation

#### 1. Clone/Setup the Project

```bash
cd "Food freshness classification from visual features"
```

#### 2. Setup Python Environment

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

#### 3. Setup Node.js Backend

```bash
cd Backend

# Install dependencies
npm install

# Create .env file from template
copy .env.example .env

# Edit .env with your database credentials
```

#### 4. Setup Database

```sql
CREATE DATABASE IF NOT EXISTS food_db;

USE food_db;

CREATE TABLE IF NOT EXISTS results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    image VARCHAR(255) NOT NULL,
    result LONGTEXT NOT NULL,
    predicted_class VARCHAR(50),
    confidence FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_created (created_at),
    INDEX idx_class (predicted_class)
);

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 📝 Configuration

### Flask Configuration (.env.flask)

```env
FLASK_ENV=production
FLASK_DEBUG=False
FLASK_HOST=0.0.0.0
FLASK_PORT=8000
UPLOAD_FOLDER=uploads
MAX_FILE_SIZE=10485760
LOG_LEVEL=INFO
MODEL_PATH=artifacts/model.h5
```

### Node.js Configuration (Backend/.env)

```env
NODE_ENV=production
PORT=3000
FLASK_API_URL=http://localhost:8000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=food_db
SERVER_HOST=0.0.0.0
SERVER_PORT=3000
LOG_LEVEL=info
```

## 🎯 Running the Application

### Terminal 1: Start Flask API

```bash
# From project root
python app.py
```

The Flask API will be available at: `http://localhost:8000`

### Terminal 2: Start Node.js Server

```bash
# From Backend directory
cd Backend
npm start

# Or for development with auto-reload:
npm run dev
```

The Web Interface will be available at: `http://localhost:3000`

## 📊 API Endpoints

### Flask API (http://localhost:8000)

- **GET** `/` - API information
- **GET** `/api/health` - Health check
- **GET** `/api/classes` - Available classes
- **GET** `/api/model-info` - Model information
- **POST** `/api/predict` - Make a prediction
- **POST** `/api/batch-predict` - Batch predictions

### Web Interface (http://localhost:3000)

- **GET** `/` - Home page
- **GET** `/prediction` - Prediction page
- **POST** `/predict` - Process prediction
- **GET** `/dashboard` - Analytics dashboard
- **GET** `/records` - Prediction history
- **GET** `/api/stats` - System statistics
- **GET** `/api/predictions` - Recent predictions

## 🔧 Model Classes

### Supported Produce Types

**Fresh:**
- Fresh Apples
- Fresh Banana
- Fresh Bitter Gourd
- Fresh Capsicum
- Fresh Cucumber
- Fresh Okra
- Fresh Oranges
- Fresh Potato
- Fresh Tomato

**Rotten:**
- Rotten Apples
- Rotten Banana
- Rotten Bitter Gourd
- Rotten Capsicum
- Rotten Cucumber
- Rotten Okra
- Rotten Oranges
- Rotten Potato
- Rotten Tomato

## 🤖 Making Predictions

### Using Web Interface

1. Go to `http://localhost:3000/prediction`
2. Click to upload or drag & drop an image
3. Click "Classify Image" button
4. View results with confidence score

### Using API

```bash
curl -X POST -F "image=@path/to/image.jpg" http://localhost:8000/api/predict
```

**Response:**

```json
{
  "status": "success",
  "success": true,
  "prediction": {
    "class": "freshapples",
    "product": "Apples",
    "freshness": "Fresh",
    "confidence": 0.95,
    "confidence_percentage": 95.0,
    "timestamp": "2024-04-25T10:30:00"
  }
}
```

## 📈 Dashboard Features

- **Real-time Statistics**: Total predictions, unique products, confidence scores
- **Charts**: Product distribution and freshness analysis
- **Prediction History**: Paginated table of all predictions
- **Confidence Visualization**: Visual confidence bars for each prediction

## 🛠️ Development

### Project Structure Best Practices

- **Separation of Concerns**: Backend (AI) and Frontend (UI) are separated
- **Error Handling**: Comprehensive error handling with custom exceptions
- **Logging**: Detailed logging for debugging and monitoring
- **Database Indexing**: Optimized queries with proper indexes
- **Security**: CORS configuration, file upload validation

### Adding New Features

1. **Add a new product**: Update `CLASS_INDICES` in `app.py` and train the model with new data
2. **Add a new page**: Create `.ejs` file in `Backend/views/`
3. **Add an API endpoint**: Create route in `app.py` or `Backend/index.js`

## 🐛 Troubleshooting

### Model Not Loading

```
Error: Model not found at artifacts/model.h5
```

**Solution**: Ensure model file exists at the specified path or train the model first

### Database Connection Error

```
Error: ECONNREFUSED 127.0.0.1:3306
```

**Solution**: 
- Ensure MySQL is running
- Check database credentials in `.env`
- Verify database exists

### CORS Error

**Solution**: CORS is already configured. Check that Flask and Node.js are on correct ports.

### File Upload Failed

**Solution**: 
- Check file size (max 10MB)
- Ensure `uploads` folder exists and has write permissions
- Check supported formats: JPEG, PNG, GIF, WebP

## 📊 Performance Optimization

- **Image Preprocessing**: Images are resized to 224x224 for faster processing
- **Database Indexes**: Queries are optimized with proper indexes
- **Async Operations**: Node.js async/await for non-blocking operations
- **Caching**: API responses are optimized

## 🔐 Security Considerations

- File upload validation (type and size)
- Secure filename generation
- SQL injection prevention with prepared statements
- CORS policy configuration
- Error messages don't expose sensitive data

## 📝 Logging

Logs are stored in the `logs/` directory:

- **Flask**: `logs/app.log`
- **Node.js**: Console output

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## 📄 License

MIT License - See LICENSE file for details

## 👨‍💻 Author

Your Name - [Your Email/GitHub]

## 🙏 Acknowledgments

- TensorFlow & Keras documentation
- Express.js best practices
- Bootstrap 5 framework
- Font Awesome icons

---

**Version**: 1.0.0  
**Last Updated**: April 2024  
**Status**: ✅ Production Ready
