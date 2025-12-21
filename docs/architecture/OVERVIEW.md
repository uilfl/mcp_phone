# Architecture Overview

## System Architecture

The MCP Phone application follows a three-tier architecture designed for security, scalability, and maintainability.

### High-Level Architecture

```
┌──────────────────────────────────────────────────────┐
│                  Mobile Clients                      │
│  ┌────────────┐              ┌────────────┐         │
│  │  Android   │              │    iOS     │         │
│  │   App      │              │    App     │         │
│  └─────┬──────┘              └──────┬─────┘         │
└────────┼─────────────────────────────┼──────────────┘
         │         HTTPS / JWT         │
         └──────────────┬──────────────┘
                        │
         ┌──────────────▼──────────────┐
         │      MCP Gateway            │
         │  (Node.js/Express)          │
         │                             │
         │  ┌─────────────────────┐   │
         │  │  Authentication      │   │
         │  │  & Authorization     │   │
         │  └─────────────────────┘   │
         │                             │
         │  ┌─────────────────────┐   │
         │  │  Rate Limiting      │   │
         │  │  & Validation       │   │
         │  └─────────────────────┘   │
         │                             │
         │  ┌─────────────────────┐   │
         │  │  Profile Router     │   │
         │  └─────────────────────┘   │
         └──────────────┬──────────────┘
                        │
         ┌──────────────▼──────────────┐
         │    MCP Server Network       │
         │                             │
         │  ┌────┐ ┌────┐ ┌────┐      │
         │  │ W  │ │ C  │ │ N  │ ...  │
         │  └────┘ └────┘ └────┘      │
         └─────────────────────────────┘
```

## Components

### 1. Mobile Client (Flutter)

**Responsibility**: User interface and client-side logic

**Key Features**:
- Cross-platform mobile application (Android & iOS)
- Material Design 3 UI components
- Local state management with Provider
- Secure credential storage
- Offline capability (future)

**Tech Stack**:
- Flutter 3.x
- Dart 3.x
- Provider (state management)
- flutter_secure_storage (credentials)
- http (API communication)

### 2. MCP Gateway (Backend)

**Responsibility**: Secure API layer between mobile clients and MCP servers

**Key Features**:
- RESTful API endpoints
- JWT-based authentication
- Request validation and sanitization
- Rate limiting per user/IP
- Connection pooling for MCP servers
- Comprehensive logging
- Error handling and recovery

**Tech Stack**:
- Node.js 18.x
- Express.js
- JWT for authentication
- Helmet.js for security
- Winston for logging
- Joi for validation

**API Endpoints**:
```
POST   /api/auth/login          - User authentication
POST   /api/auth/logout         - User logout
POST   /api/auth/refresh        - Token refresh
GET    /api/profiles            - List profiles
GET    /api/profiles/:id        - Get profile details
POST   /api/chat                - Send chat message
GET    /api/chat/history/:id    - Get conversation history
GET    /health                  - Health check
```

### 3. MCP Profiles

**Responsibility**: Curated configurations for MCP services

**Structure**:
```json
{
  "id": "profile-id",
  "name": "Display Name",
  "description": "Profile description",
  "icon": "emoji",
  "version": "1.0.0",
  "capabilities": ["cap1", "cap2"],
  "configuration": {},
  "mcpServerUrl": "https://...",
  "authentication": {},
  "rateLimits": {}
}
```

**Available Profiles**:
- Weather Assistant
- Calendar Manager
- Notes Assistant
- Task Manager

## Data Flow

### Authentication Flow

```
1. User enters credentials
   ↓
2. Mobile app sends to /api/auth/login
   ↓
3. Gateway validates credentials
   ↓
4. Gateway generates JWT token
   ↓
5. Token returned to mobile app
   ↓
6. Mobile app stores token securely
   ↓
7. Token included in all subsequent requests
```

### Chat Message Flow

```
1. User types message
   ↓
2. Mobile app sends to /api/chat
   ↓
3. Gateway validates token & input
   ↓
4. Gateway routes to appropriate MCP server
   ↓
5. MCP server processes request
   ↓
6. Response flows back through gateway
   ↓
7. Gateway transforms & returns response
   ↓
8. Mobile app displays response
```

## Security Architecture

### Layers of Security

1. **Transport Security**
   - HTTPS/TLS 1.3 for all communications
   - Certificate pinning (future)

2. **Authentication & Authorization**
   - JWT tokens with expiration
   - Refresh token mechanism
   - Role-based access control (future)

3. **Input Validation**
   - Schema-based validation (Joi)
   - Sanitization of all inputs
   - SQL injection prevention
   - XSS prevention

4. **Rate Limiting**
   - Per-user limits
   - Per-IP limits
   - Per-endpoint limits

5. **API Security**
   - CORS configuration
   - Security headers (Helmet.js)
   - Request size limits
   - Timeout enforcement

6. **Data Protection**
   - Secure storage on mobile
   - Encrypted credentials
   - No sensitive data in logs

## Scalability Considerations

### Horizontal Scaling

The gateway is designed to be stateless, allowing horizontal scaling:

```
         Load Balancer
              │
    ┌─────────┼─────────┐
    │         │         │
Gateway 1  Gateway 2  Gateway 3
    │         │         │
    └─────────┼─────────┘
              │
        MCP Servers
```

### Caching Strategy

- Profile configurations cached in memory
- Response caching for read-heavy operations
- Redis for distributed caching (future)

### Database Strategy

- Currently using in-memory storage
- Future: PostgreSQL for persistence
- Separate read/write databases (future)

## Monitoring & Observability

### Logging

- Structured logging (JSON format)
- Different log levels (debug, info, warn, error)
- Request/response logging
- Error tracking

### Metrics (Future)

- Request rate
- Response time
- Error rate
- Active users
- MCP server health

### Alerting (Future)

- High error rate alerts
- Performance degradation alerts
- Security incident alerts

## Deployment Architecture

### Development Environment

```
Developer Machine
├── Mobile App (Flutter)
├── Gateway (localhost:3000)
└── Mock MCP Servers
```

### Production Environment

```
Cloud Infrastructure
├── Mobile Apps (App Store / Play Store)
├── API Gateway Cluster (Kubernetes)
├── Load Balancer
├── Database Cluster
└── MCP Server Network
```

## Technology Decisions

### Why Flutter?

- Single codebase for Android & iOS
- Native performance
- Rich UI components
- Hot reload for fast development
- Strong community support

### Why Node.js/Express?

- JavaScript/TypeScript ecosystem
- High performance for I/O operations
- Large middleware ecosystem
- Easy to scale
- Good for API development

### Why JWT?

- Stateless authentication
- Works well with mobile apps
- Industry standard
- Easy to implement
- Scalable

## Future Enhancements

1. **Offline Support**
   - Local database (SQLite)
   - Sync queue for offline changes
   - Conflict resolution

2. **Real-time Updates**
   - WebSocket support
   - Push notifications
   - Live chat updates

3. **Advanced Features**
   - Voice input
   - Multi-language support
   - Dark mode
   - Accessibility improvements

4. **Performance**
   - Response caching
   - Image optimization
   - Lazy loading
   - Code splitting

5. **Analytics**
   - User behavior tracking
   - Performance monitoring
   - Error tracking
   - Usage statistics
