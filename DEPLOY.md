# Aura-Pet Deployment Guide

## 🚀 Quick Start

### Option 1: Docker Compose (Recommended)

```bash
# Clone and start all services
cd aura-pet
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f api
```

**Services will be available at:**
- API: http://localhost:8000
- API Docs: http://localhost:8000/docs
- Frontend: http://localhost:8080
- PostgreSQL: localhost:5432

---

### Option 2: Manual Setup

#### 1. Database Setup

```bash
# Create PostgreSQL database
psql -U postgres
CREATE DATABASE aura_pet;
\q

# Run migrations
cd backend
alembic upgrade head
```

#### 2. Backend API

```bash
cd backend

# Install dependencies
pip install -r requirements.txt

# Set environment variables
export DATABASE_URL="postgresql://postgres:postgres@localhost:5432/aura_pet"
export SECRET_KEY="your-secret-key-here"

# Run the server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

#### 3. Frontend

```bash
# Simple HTTP server
cd frontend
python -m http.server 8080

# Or use any static file server
npx serve -p 8080
```

---

## 🌐 Production Deployment

### Vercel (Frontend + Serverless Functions)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy frontend
cd frontend
vercel --prod
```

### Railway (Full Stack)

1. Connect GitHub repository
2. Railway will auto-detect Docker configuration
3. Add environment variables:
   - `DATABASE_URL`
   - `SECRET_KEY`
   - `REDIS_URL`

### Render (Full Stack)

1. Create new Web Service
2. Connect GitHub repository
3. Set build command: `pip install -r requirements.txt`
4. Set start command: `uvicorn main:app --host 0.0.0.0 --port $PORT`

### AWS (ECS + RDS)

```bash
# Build and push Docker image
aws ecr get-login-password | docker login --username AWS --password-stdin <account>.dkr.ecr.<region>.amazonaws.com
docker build -t aura-pet-api ./backend
docker tag aura-pet-api <account>.dkr.ecr.<region>.amazonaws.com/aura-pet-api:latest
docker push <account>.dkr.ecr.<region>.amazonaws.com/aura-pet-api:latest
```

---

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://postgres:postgres@localhost:5432/aura_pet` |
| `SECRET_KEY` | JWT signing secret | Required |
| `REDIS_URL` | Redis connection string | `redis://localhost:6379` |
| `SQL_ECHO` | Log SQL queries | `false` |
| `CORS_ORIGINS` | Allowed CORS origins | `*` |

### Database Migrations

```bash
# Create a new migration
alembic revision --autogenerate -m "Add new table"

# Run migrations
alembic upgrade head

# Rollback
alembic downgrade -1
```

---

## 📱 Mobile App

### Flutter Build

```bash
cd frontend/flutter_app

# Install dependencies
flutter pub get

# Build for iOS
flutter build ios --release

# Build for Android
flutter build apk --release

# Build for Web
flutter build web
```

### Native Build (iOS)

```bash
# Open in Xcode
open ios/Runner.xcworkspace

# Or build from command line
flutter build ios --release --no-codesign
```

---

## 🧪 Testing

### Backend Tests

```bash
cd backend

# Run all tests
pytest

# Run with coverage
pytest --cov=. --cov-report=html

# Run specific test file
pytest tests/test_api.py -v
```

### API Health Check

```bash
# Local
curl http://localhost:8000/health

# Docker
curl http://localhost:8000/health
```

---

## 🔒 Security Checklist

- [ ] Change `SECRET_KEY` in production
- [ ] Set up SSL/TLS (HTTPS)
- [ ] Configure proper CORS origins
- [ ] Enable rate limiting
- [ ] Set up database backups
- [ ] Use environment variables for secrets
- [ ] Enable Redis for session caching

---

## 📊 Monitoring

### Health Check Endpoint

```
GET /health
```

Returns:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

### Metrics (Prometheus)

```
GET /metrics
```

---

## 🆘 Troubleshooting

### Database Connection Issues

```bash
# Check if PostgreSQL is running
docker-compose ps db

# Test connection
psql -U postgres -d aura_pet -c "SELECT 1;"
```

### API Not Responding

```bash
# Check API logs
docker-compose logs api

# Restart API
docker-compose restart api
```

### Migrations Failed

```bash
# Reset database
alembic downgrade base
alembic upgrade head
```

---

## 📞 Support

For issues and questions, please contact:
- Email: support@aura-pet.com
- GitHub Issues: https://github.com/aura-pet/aura-pet/issues
