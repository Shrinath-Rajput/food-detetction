-- ================================================
-- Food Freshness Classification Database Setup
-- ================================================
-- Run this in MySQL Workbench or MySQL command line
-- ================================================

-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS food_db;
USE food_db;

-- Step 2: Drop existing tables (if any - to start fresh)
DROP TABLE IF EXISTS results;
DROP TABLE IF EXISTS users;

-- Step 3: Create Results Table
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Step 4: Create Users Table
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Step 5: Verify Tables
SHOW TABLES;
DESCRIBE results;
DESCRIBE users;

-- Step 6: Insert Test Data (Optional)
INSERT INTO results (image, result, predicted_class, confidence, product_name, freshness) 
VALUES 
  ('test1.jpg', '{"class":"freshapples","confidence":0.95}', 'freshapples', 0.95, 'Apples', 'Fresh'),
  ('test2.jpg', '{"class":"rottenbanana","confidence":0.87}', 'rottenbanana', 0.87, 'Banana', 'Rotten');

-- Step 7: Verify Data
SELECT * FROM results;
SELECT COUNT(*) as total_predictions FROM results;
