# 🚀 Deployment Guide

## Local Development Deployment

### Prerequisites
- Python 3.8+
- Node.js 14+
- MySQL 5.7+

### Step 1: Environment Setup

```bash
# Create virtual environment
python -m venv venv
venv\Scripts\activate  # Windows
# or
source venv/bin/activate  # macOS/Linux

# Install dependencies
pip install -r requirements.txt

# Setup Node.js
cd Backend
npm install
```

### Step 2: Database Setup

```bash
# Using provided SQL file
mysql -u root -p < database_setup.sql

# Or manually
mysql -u root -p
> CREATE DATABASE food_db;
> USE food_db;
> [Run queries from database_setup.sql]
```

### Step 3: Configuration

**Flask (.env.flask):**
```env
FLASK_ENV=development
FLASK_DEBUG=True
FLASK_HOST=127.0.0.1
FLASK_PORT=8000
```

**Node.js (Backend/.env):**
```env
NODE_ENV=development
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=food_db
```

### Step 4: Start Services

```bash
# Terminal 1: Flask API
python app.py

# Terminal 2: Node.js Backend
cd Backend
npm run dev
```

---

## Production Deployment

### Using Gunicorn + Nginx + PM2

#### 1. Production Configuration

**Flask (.env.flask):**
```env
FLASK_ENV=production
FLASK_DEBUG=False
```

**Node.js (Backend/.env):**
```env
NODE_ENV=production
PORT=3000
```

#### 2. Deploy Flask API with Gunicorn

```bash
# Install Gunicorn
pip install gunicorn

# Run with Gunicorn
gunicorn -w 4 -b 0.0.0.0:8000 app:app

# Or create systemd service
sudo nano /etc/systemd/system/food-api.service
```

**food-api.service:**
```ini
[Unit]
Description=Food Freshness Classification API
After=network.target

[Service]
User=www-data
WorkingDirectory=/path/to/project
ExecStart=/path/to/venv/bin/gunicorn -w 4 -b 0.0.0.0:8000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
```

#### 3. Deploy Node.js with PM2

```bash
# Install PM2 globally
npm install -g pm2

# Start with PM2
cd Backend
pm2 start index.js --name "food-backend"

# Save PM2 configuration
pm2 save

# Enable PM2 startup on boot
pm2 startup
```

#### 4. Configure Nginx Reverse Proxy

```nginx
# /etc/nginx/sites-available/food-classification

upstream flask_api {
    server 127.0.0.1:8000;
}

upstream node_backend {
    server 127.0.0.1:3000;
}

server {
    listen 80;
    server_name yourdomain.com;

    # Flask API
    location /api/ {
        proxy_pass http://flask_api;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Node.js Backend
    location / {
        proxy_pass http://node_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # SSL Configuration (Let's Encrypt)
    # listen 443 ssl http2;
    # ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    # ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
}
```

#### 5. Enable Nginx Configuration

```bash
# Create symlink
sudo ln -s /etc/nginx/sites-available/food-classification /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

---

## Docker Deployment

### Dockerfile (Flask API)

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app:app"]
```

### Dockerfile (Node.js Backend)

```dockerfile
FROM node:14-slim

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY Backend/ .

EXPOSE 3000

CMD ["npm", "start"]
```

### Docker Compose

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: food_db
    volumes:
      - mysql_data:/var/lib/mysql
      - ./database_setup.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "3306:3306"

  flask_api:
    build: .
    ports:
      - "8000:8000"
    depends_on:
      - mysql
    environment:
      FLASK_ENV: production
    volumes:
      - ./uploads:/app/uploads

  node_backend:
    build:
      context: .
      dockerfile: Backend/Dockerfile
    ports:
      - "3000:3000"
    depends_on:
      - flask_api
      - mysql
    environment:
      NODE_ENV: production
      FLASK_API_URL: http://flask_api:8000
      DB_HOST: mysql

volumes:
  mysql_data:
```

**Deploy with Docker Compose:**
```bash
docker-compose up -d
```

---

## Cloud Deployment

### AWS Deployment

1. **EC2 Instance Setup**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install python3 python3-pip nodejs npm mysql-server nginx -y

# Clone repository
git clone https://github.com/your-repo.git
cd Food-Freshness-Classification
```

2. **RDS Database**
```bash
# Use AWS RDS MySQL
# Update DB connection in .env files
```

3. **S3 for Uploads** (Optional)
```python
# Use boto3 for S3 file storage
import boto3
s3 = boto3.client('s3')
```

### Heroku Deployment

1. **Create Procfile**
```
web: gunicorn app:app
worker: npm --prefix Backend start
```

2. **Deploy**
```bash
heroku login
heroku create food-freshness-app
git push heroku main
```

---

## Monitoring & Maintenance

### Application Monitoring

```bash
# View logs
pm2 logs

# Monitor resources
pm2 monit

# Restart services
pm2 restart all
pm2 stop all
pm2 delete all
```

### Database Maintenance

```sql
-- Backup
mysqldump -u root -p food_db > backup.sql

-- Optimize tables
OPTIMIZE TABLE results;

-- Check disk usage
SELECT table_name, ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size in MB"
FROM information_schema.tables
WHERE table_schema = 'food_db';
```

### Scheduled Tasks

```bash
# Daily backup with cron
0 2 * * * mysqldump -u root -p food_db > /backups/food_db_$(date +\%Y\%m\%d).sql

# Log rotation
logrotate -f /etc/logrotate.d/food-app
```

---

## Security Checklist

- [ ] Use HTTPS/SSL certificates
- [ ] Strong database password
- [ ] Firewall rules configured
- [ ] File upload validation
- [ ] Rate limiting configured
- [ ] CORS properly configured
- [ ] Environment variables secured
- [ ] Regular backups scheduled
- [ ] Error logging without sensitive data
- [ ] Database user with limited permissions

---

## Performance Optimization

```bash
# Database connection pooling
# Cache predictions (Redis)
# CDN for static files
# Compress responses (gzip)
# Image optimization
# Database query optimization
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| High memory usage | Reduce worker count, optimize queries |
| Slow uploads | Increase nginx upload limit, optimize images |
| Database errors | Check connection, verify permissions |
| 502 Bad Gateway | Check upstream services |
| Timeout errors | Increase timeout values |

---

## Support & Documentation

- **Documentation**: See README.md
- **Quick Start**: See QUICK_START.md
- **API Docs**: http://yourdomain.com/api/
- **Issues**: Check logs in `logs/` directory

---

**Version**: 1.0.0  
**Last Updated**: April 2024
