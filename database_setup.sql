-- ==========================================
-- FOOD FRESHNESS DATABASE SETUP
-- ==========================================

-- Drop existing database (optional)
-- DROP DATABASE IF EXISTS food_db;

-- Create database
CREATE DATABASE IF NOT EXISTS food_db;
USE food_db;

-- ==========================================
-- USERS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- RESULTS TABLE - Main predictions storage
-- ==========================================
CREATE TABLE IF NOT EXISTS results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    image VARCHAR(255) NOT NULL,
    result LONGTEXT NOT NULL COMMENT 'JSON result with all predictions',
    predicted_class VARCHAR(50) NOT NULL,
    confidence FLOAT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes for faster queries
    INDEX idx_created (created_at),
    INDEX idx_class (predicted_class),
    INDEX idx_confidence (confidence),
    
    -- Check constraints
    CONSTRAINT chk_confidence CHECK (confidence >= 0 AND confidence <= 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- STATISTICS VIEW
-- ==========================================
CREATE OR REPLACE VIEW prediction_statistics AS
SELECT 
    COUNT(*) as total_predictions,
    COUNT(DISTINCT predicted_class) as unique_classes,
    AVG(confidence) as avg_confidence,
    MAX(confidence) as max_confidence,
    MIN(confidence) as min_confidence,
    DATE(created_at) as prediction_date
FROM results
GROUP BY DATE(created_at)
ORDER BY prediction_date DESC;

-- ==========================================
-- CLASS STATISTICS VIEW
-- ==========================================
CREATE OR REPLACE VIEW class_statistics AS
SELECT 
    predicted_class,
    COUNT(*) as count,
    AVG(confidence) as avg_confidence,
    MAX(confidence) as max_confidence,
    MIN(confidence) as min_confidence,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM results), 2) as percentage
FROM results
GROUP BY predicted_class
ORDER BY count DESC;

-- ==========================================
-- SAMPLE DATA (Optional)
-- ==========================================
-- Uncomment to insert sample data for testing

/*
INSERT INTO results (image, result, predicted_class, confidence) VALUES 
('uploads/sample1.jpg', '{"class":"freshapples","confidence":0.95}', 'freshapples', 0.95),
('uploads/sample2.jpg', '{"class":"rottenbanana","confidence":0.87}', 'rottenbanana', 0.87),
('uploads/sample3.jpg', '{"class":"freshcucumber","confidence":0.92}', 'freshcucumber', 0.92);
*/

-- ==========================================
-- QUERY EXAMPLES
-- ==========================================
-- Get total predictions:
-- SELECT COUNT(*) as total_predictions FROM results;

-- Get fresh items count:
-- SELECT COUNT(*) FROM results WHERE predicted_class LIKE 'fresh%';

-- Get rotten items count:
-- SELECT COUNT(*) FROM results WHERE predicted_class LIKE 'rotten%';

-- Get predictions by date:
-- SELECT DATE(created_at), COUNT(*) FROM results GROUP BY DATE(created_at);

-- Get all statistics:
-- SELECT * FROM prediction_statistics;

-- Get class distribution:
-- SELECT * FROM class_statistics;
