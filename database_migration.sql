-- ================================================
-- Database Migration - Add Missing Columns
-- ================================================
-- Run this if the results table already exists but is missing columns

USE food_db;

-- Check if column exists, if not add it
ALTER TABLE results 
ADD COLUMN IF NOT EXISTS predicted_class VARCHAR(50),
ADD COLUMN IF NOT EXISTS confidence FLOAT,
ADD COLUMN IF NOT EXISTS product_name VARCHAR(100),
ADD COLUMN IF NOT EXISTS freshness VARCHAR(20);

-- Create indexes if they don't exist
CREATE INDEX IF NOT EXISTS idx_predicted_class ON results(predicted_class);
CREATE INDEX IF NOT EXISTS idx_created_at ON results(created_at);
CREATE INDEX IF NOT EXISTS idx_freshness ON results(freshness);

-- Verify the table structure
DESCRIBE results;

-- Show all columns
SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'results' AND TABLE_SCHEMA = 'food_db';
