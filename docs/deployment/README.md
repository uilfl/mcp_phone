# Deployment Guide

This guide covers deploying the MCP Phone application to production environments.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Mobile App Deployment](#mobile-app-deployment)
- [Gateway Deployment](#gateway-deployment)
- [Docker Deployment](#docker-deployment)
- [Cloud Deployment](#cloud-deployment)
- [Post-Deployment](#post-deployment)

## Overview

The MCP Phone application consists of two main components:

1. **Mobile Apps**: Flutter apps for Android and iOS
2. **Gateway**: Node.js backend API server

Both components must be deployed and configured correctly for the system to function.

## Prerequisites

### General Requirements

- Domain name with SSL certificate
- Cloud hosting account (AWS, GCP, Azure, or similar)
- CI/CD pipeline (GitHub Actions, GitLab CI, etc.)
- Monitoring and logging infrastructure

### Mobile App Requirements

- Apple Developer Account (for iOS)
- Google Play Developer Account (for Android)
- Code signing certificates
- App store assets (icons, screenshots, descriptions)

### Gateway Requirements

- Node.js 18.x or higher
- SSL/TLS certificate
- Database (future)
- Environment variables configured

## Mobile App Deployment

### Android Deployment

#### 1. Prepare Release Build

```bash
cd mobile_app

# Generate release keystore (first time only)
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Create key.properties file
echo "storePassword=<password>" > android/key.properties
echo "keyPassword=<password>" >> android/key.properties
echo "keyAlias=upload" >> android/key.properties
echo "storeFile=~/upload-keystore.jks" >> android/key.properties

# Build release APK
flutter build apk --release

# Or build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### 2. Test Release Build

```bash
# Install and test on device
flutter install --release
```

#### 3. Upload to Google Play

1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app or select existing
3. Navigate to "Release" → "Production"
4. Upload `build/app/outputs/bundle/release/app-release.aab`
5. Fill in release notes
6. Submit for review

### iOS Deployment

#### 1. Configure Xcode Project

```bash
cd mobile_app

# Open in Xcode
open ios/Runner.xcworkspace

# In Xcode:
# - Set Team and Bundle Identifier
# - Configure Signing & Capabilities
# - Set deployment target (iOS 12.0+)
```

#### 2. Build for Release

```bash
# Build release IPA
flutter build ios --release

# Or archive in Xcode:
# Product → Archive
# Organizer → Distribute App
```

#### 3. Submit to App Store

1. Open Xcode Organizer
2. Select archive
3. Click "Distribute App"
4. Follow App Store Connect wizard
5. Submit for review

### Mobile App Configuration

Update gateway URL before release:

```dart
// lib/services/mcp_gateway_service.dart
class MCPGatewayService extends ChangeNotifier {
  static const String _baseUrl = 'https://api.your-domain.com/api';
  // ...
}
```

## Gateway Deployment

### Option 1: Traditional Server Deployment

#### 1. Server Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2 (process manager)
sudo npm install -g pm2

# Create app user
sudo useradd -m -d /home/mcp-gateway mcp-gateway
```

#### 2. Deploy Application

```bash
# Clone repository
cd /home/mcp-gateway
sudo -u mcp-gateway git clone https://github.com/uilfl/mcp_phone.git
cd mcp_phone/gateway

# Install dependencies
sudo -u mcp-gateway npm ci --only=production

# Create .env file
sudo -u mcp-gateway cp .env.example .env
sudo -u mcp-gateway nano .env
# Configure environment variables

# Start with PM2
sudo -u mcp-gateway pm2 start src/index.js --name mcp-gateway
sudo -u mcp-gateway pm2 save
sudo -u mcp-gateway pm2 startup
```

#### 3. Configure Nginx

```nginx
# /etc/nginx/sites-available/mcp-gateway
server {
    listen 80;
    server_name api.your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.your-domain.com;

    ssl_certificate /etc/letsencrypt/live/api.your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.your-domain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/mcp-gateway /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Option 2: Docker Deployment

See [Docker Deployment](#docker-deployment) section below.

### Environment Variables

Required production environment variables:

```bash
NODE_ENV=production
PORT=3000

# Generate strong secret
JWT_SECRET=<generate-random-string>
JWT_EXPIRES_IN=24h

RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Your mobile app URLs
ALLOWED_ORIGINS=https://your-domain.com

MCP_TIMEOUT=30000
MCP_MAX_RETRIES=3

LOG_LEVEL=info
```

## Docker Deployment

### Build and Run

```bash
# Build image
cd gateway
docker build -t mcp-gateway:latest .

# Run container
docker run -d \
  --name mcp-gateway \
  -p 3000:3000 \
  --env-file .env \
  --restart unless-stopped \
  mcp-gateway:latest

# Check logs
docker logs -f mcp-gateway
```

### Docker Compose

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Update and restart
git pull
docker-compose build
docker-compose up -d
```

## Cloud Deployment

### AWS Deployment

#### Using Elastic Beanstalk

```bash
# Install EB CLI
pip install awsebcli

# Initialize
cd gateway
eb init -p node.js-18 mcp-gateway

# Create environment
eb create mcp-gateway-prod

# Deploy
eb deploy

# Configure environment variables
eb setenv JWT_SECRET=xxx ALLOWED_ORIGINS=xxx
```

#### Using ECS (Docker)

1. Push image to ECR
2. Create ECS cluster
3. Create task definition
4. Create service
5. Configure load balancer

### Google Cloud Platform

#### Using Cloud Run

```bash
# Build and deploy
cd gateway
gcloud builds submit --tag gcr.io/PROJECT_ID/mcp-gateway
gcloud run deploy mcp-gateway \
  --image gcr.io/PROJECT_ID/mcp-gateway \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### Azure

#### Using App Service

```bash
# Deploy to Azure
cd gateway
az webapp up \
  --name mcp-gateway \
  --resource-group mcp-rg \
  --plan mcp-plan \
  --runtime "NODE|18-lts"
```

## Post-Deployment

### Health Check

```bash
# Check gateway health
curl https://api.your-domain.com/health

# Expected response:
{
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "uptime": 12345.67
}
```

### Monitoring

#### Set Up Monitoring

```bash
# PM2 monitoring (if using PM2)
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 10M
pm2 set pm2-logrotate:retain 7

# View metrics
pm2 monit
```

#### Log Management

```bash
# View logs
pm2 logs mcp-gateway

# Or with Docker
docker logs -f mcp-gateway

# Set up log forwarding to CloudWatch/Stackdriver/etc.
```

### Security Checklist

- [ ] HTTPS enabled and enforced
- [ ] SSL certificate valid and auto-renewing
- [ ] Strong JWT secret configured
- [ ] CORS configured correctly
- [ ] Rate limiting enabled
- [ ] Firewall rules configured
- [ ] Security headers enabled
- [ ] Secrets not in source code
- [ ] Regular security updates scheduled
- [ ] Monitoring and alerting configured

### Performance Optimization

```bash
# Enable Node.js production optimizations
export NODE_ENV=production

# Use clustering (PM2)
pm2 start src/index.js -i max

# Enable HTTP/2
# Configure in Nginx or load balancer

# Set up CDN for static assets
# CloudFlare, CloudFront, etc.
```

### Backup Strategy

```bash
# Database backups (when implemented)
# Daily automated backups
# 30-day retention
# Encrypted backups
# Test restore procedures

# Configuration backups
# Version control for configs
# Secure storage for secrets
```

### Rollback Procedure

```bash
# PM2 rollback
pm2 stop mcp-gateway
cd /home/mcp-gateway/mcp_phone
git checkout <previous-commit>
cd gateway
npm ci --only=production
pm2 restart mcp-gateway

# Docker rollback
docker stop mcp-gateway
docker run -d --name mcp-gateway mcp-gateway:previous-version

# Cloud platform rollback
# Use platform-specific rollback commands
```

## Continuous Deployment

### GitHub Actions Example

```yaml
# .github/workflows/deploy.yml
name: Deploy Gateway

on:
  push:
    branches: [main]
    paths:
      - 'gateway/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        working-directory: ./gateway
        run: npm ci
      
      - name: Run tests
        working-directory: ./gateway
        run: npm test
      
      - name: Deploy to production
        run: |
          # Your deployment commands here
          # ssh, docker push, eb deploy, etc.
```

## Troubleshooting

### Gateway Not Starting

```bash
# Check logs
pm2 logs mcp-gateway --lines 100

# Check port availability
sudo netstat -tlnp | grep 3000

# Check environment variables
pm2 env 0

# Restart service
pm2 restart mcp-gateway
```

### SSL/Certificate Issues

```bash
# Test SSL
curl -v https://api.your-domain.com/health

# Renew Let's Encrypt certificate
sudo certbot renew

# Check certificate expiration
echo | openssl s_client -connect api.your-domain.com:443 2>/dev/null | openssl x509 -noout -dates
```

### High Memory Usage

```bash
# Check memory
pm2 list
free -h

# Restart with memory limit
pm2 restart mcp-gateway --max-memory-restart 500M

# Investigate memory leaks
node --inspect src/index.js
```

## Support

For deployment issues:
- Check [documentation](../README.md)
- Review [troubleshooting guide](#troubleshooting)
- Open [GitHub issue](https://github.com/uilfl/mcp_phone/issues)
- Contact support@mcpphone.example.com

---

**Last Updated**: 2024-01-01
