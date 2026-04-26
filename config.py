"""
Configuration and Constants for Food Freshness Classification System
"""

# ==================== MODEL CONFIGURATION ====================
class ModelConfig:
    """Model configuration constants"""
    
    # Input image size
    IMAGE_HEIGHT = 224
    IMAGE_WIDTH = 224
    IMAGE_CHANNELS = 3
    IMAGE_SHAPE = (IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_CHANNELS)
    
    # Model paths
    MODEL_PATH = "artifacts/model.h5"
    WEIGHTS_PATH = "artifacts/model_weights.h5"
    
    # Training configuration
    BATCH_SIZE = 32
    EPOCHS = 25
    LEARNING_RATE = 0.001
    VALIDATION_SPLIT = 0.2
    
    # Model type
    MODEL_TYPE = "CNN"
    FRAMEWORK = "TensorFlow/Keras"
    
    # Classes
    TOTAL_CLASSES = 18
    FRESH_CLASSES = 9
    ROTTEN_CLASSES = 9


# ==================== CLASS MAPPING ====================
class ClassMapping:
    """Product class mapping"""
    
    CLASSES = {
        'freshapples': 0,
        'freshbanana': 1,
        'freshbittergroud': 2,
        'freshcapsicum': 3,
        'freshcucumber': 4,
        'freshokra': 5,
        'freshoranges': 6,
        'freshpotato': 7,
        'freshtomato': 8,
        'rottenapples': 9,
        'rottenbanana': 10,
        'rottenbittergroud': 11,
        'rottencapsicum': 12,
        'rottencucumber': 13,
        'rottenokra': 14,
        'rottenoranges': 15,
        'rottenpatato': 16,
        'rottentamto': 17
    }
    
    REVERSE_CLASSES = {v: k for k, v in CLASSES.items()}
    
    PRODUCT_NAMES = {
        'apples': 'Apples',
        'banana': 'Banana',
        'bittergroud': 'Bitter Gourd',
        'capsicum': 'Capsicum',
        'cucumber': 'Cucumber',
        'okra': 'Okra',
        'oranges': 'Oranges',
        'potato': 'Potato',
        'tomato': 'Tomato',
        'patato': 'Potato',
        'tamto': 'Tomato'
    }
    
    FRESH_CLASSES = [k for k in CLASSES.keys() if 'fresh' in k]
    ROTTEN_CLASSES = [k for k in CLASSES.keys() if 'rotten' in k]


# ==================== FILE UPLOAD CONFIGURATION ====================
class FileConfig:
    """File upload configuration"""
    
    UPLOAD_FOLDER = 'uploads'
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'webp'}
    MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB
    MAX_FILE_SIZE_MB = 10
    
    # MIME types
    ALLOWED_MIMES = {
        'image/jpeg',
        'image/png',
        'image/gif',
        'image/webp'
    }


# ==================== DATABASE CONFIGURATION ====================
class DatabaseConfig:
    """Database configuration"""
    
    # Connection
    HOST = 'localhost'
    USER = 'root'
    PASSWORD = ''
    DATABASE = 'food_db'
    
    # Pool settings
    POOL_SIZE = 10
    MAX_OVERFLOW = 20
    POOL_TIMEOUT = 30
    POOL_RECYCLE = 3600
    
    # Charset
    CHARSET = 'utf8mb4'


# ==================== API CONFIGURATION ====================
class APIConfig:
    """API configuration"""
    
    # Flask API
    FLASK_HOST = '0.0.0.0'
    FLASK_PORT = 8000
    FLASK_DEBUG = False
    
    # Node.js Backend
    NODE_HOST = '0.0.0.0'
    NODE_PORT = 3000
    
    # API base URLs
    FLASK_API_URL = 'http://localhost:8000'
    NODE_API_URL = 'http://localhost:3000'
    
    # CORS settings
    CORS_ORIGINS = ['http://localhost:3000', 'http://127.0.0.1:3000']
    CORS_METHODS = ['GET', 'POST', 'OPTIONS']
    CORS_ALLOW_HEADERS = ['Content-Type', 'Authorization']


# ==================== LOGGING CONFIGURATION ====================
class LogConfig:
    """Logging configuration"""
    
    # Log levels
    LOG_LEVEL = 'INFO'
    LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    DATE_FORMAT = '%Y-%m-%d %H:%M:%S'
    
    # Log files
    LOG_FOLDER = 'logs'
    APP_LOG_FILE = 'logs/app.log'
    ERROR_LOG_FILE = 'logs/error.log'
    
    # Max log size
    MAX_LOG_SIZE = 10 * 1024 * 1024  # 10MB
    BACKUP_COUNT = 5


# ==================== CONFIDENCE THRESHOLDS ====================
class ConfidenceThresholds:
    """Confidence threshold settings"""
    
    # Minimum confidence for valid prediction
    MIN_CONFIDENCE = 0.5
    
    # Confidence levels
    VERY_HIGH = 0.9  # >= 90%
    HIGH = 0.8       # >= 80%
    MODERATE = 0.7   # >= 70%
    LOW = 0.5        # >= 50%
    
    # Color coding
    COLORS = {
        'very_high': '#28a745',  # Green
        'high': '#17a2b8',       # Blue
        'moderate': '#ffc107',   # Yellow
        'low': '#dc3545'         # Red
    }


# ==================== RESPONSE MESSAGES ====================
class Messages:
    """Application messages"""
    
    # Success messages
    PREDICTION_SUCCESS = "Prediction completed successfully"
    MODEL_LOADED = "Model loaded successfully"
    FILE_UPLOADED = "File uploaded successfully"
    DATABASE_CONNECTED = "Database connected successfully"
    
    # Error messages
    MODEL_NOT_LOADED = "Model not loaded. Please check server logs."
    NO_IMAGE_PROVIDED = "No image file provided in request"
    NO_FILE_SELECTED = "No file selected"
    INVALID_FILE_TYPE = "File type not allowed. Supported: {formats}"
    FILE_TOO_LARGE = "File size exceeds maximum allowed size of {size}MB"
    PREDICTION_FAILED = "Prediction failed. Please try again."
    DATABASE_ERROR = "Database connection error"
    SERVER_ERROR = "Internal server error"
    
    # Info messages
    PROCESSING_IMAGE = "Processing image: {filename}"
    DATABASE_TABLES_CREATED = "Database tables created successfully"


# ==================== SYSTEM STATUS ====================
class SystemStatus:
    """System status constants"""
    
    STATUS_OK = "OK"
    STATUS_ERROR = "ERROR"
    STATUS_WARNING = "WARNING"
    
    FRESH = "Fresh"
    ROTTEN = "Rotten"


if __name__ == "__main__":
    # Test configuration
    print("=" * 60)
    print("FOOD FRESHNESS CLASSIFICATION - CONFIGURATION")
    print("=" * 60)
    print(f"Model Path: {ModelConfig.MODEL_PATH}")
    print(f"Image Shape: {ModelConfig.IMAGE_SHAPE}")
    print(f"Total Classes: {ModelConfig.TOTAL_CLASSES}")
    print(f"Upload Folder: {FileConfig.UPLOAD_FOLDER}")
    print(f"Max File Size: {FileConfig.MAX_FILE_SIZE_MB}MB")
    print(f"Flask API: {APIConfig.FLASK_API_URL}")
    print(f"Node Backend: {APIConfig.NODE_API_URL}")
    print("=" * 60)
