# API Reference

Base URL: `http://localhost:3000/api` (Development)

All API requests require authentication except for `/auth/login`.

## Authentication

### Login

Authenticate a user and receive a JWT token.

**Endpoint**: `POST /api/auth/login`

**Request Body**:
```json
{
  "username": "string",
  "password": "string"
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "data": {
    "userId": "string",
    "accessToken": "string",
    "expiresAt": "2024-01-01T00:00:00.000Z"
  }
}
```

**Error Response** (400/401):
```json
{
  "success": false,
  "error": {
    "message": "Error description"
  }
}
```

### Logout

Invalidate the current session.

**Endpoint**: `POST /api/auth/logout`

**Headers**:
```
Authorization: Bearer <token>
```

**Response** (200 OK):
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

### Refresh Token

Refresh an expired or expiring token.

**Endpoint**: `POST /api/auth/refresh`

**Headers**:
```
Authorization: Bearer <token>
```

**Response** (200 OK):
```json
{
  "success": true,
  "data": {
    "accessToken": "string",
    "expiresAt": "2024-01-01T00:00:00.000Z"
  }
}
```

## Profiles

### List All Profiles

Get all available MCP profiles.

**Endpoint**: `GET /api/profiles`

**Headers**:
```
Authorization: Bearer <token>
```

**Response** (200 OK):
```json
{
  "success": true,
  "data": {
    "profiles": [
      {
        "id": "weather",
        "name": "Weather Assistant",
        "description": "Get weather information and forecasts",
        "icon": "🌤️",
        "version": "1.0.0",
        "capabilities": ["weather_current", "weather_forecast"],
        "isActive": true
      }
    ],
    "count": 1
  }
}
```

### Get Profile Details

Get detailed information about a specific profile.

**Endpoint**: `GET /api/profiles/:profileId`

**Parameters**:
- `profileId` (path): Profile identifier

**Headers**:
```
Authorization: Bearer <token>
```

**Response** (200 OK):
```json
{
  "success": true,
  "data": {
    "profile": {
      "id": "weather",
      "name": "Weather Assistant",
      "description": "Get weather information and forecasts",
      "icon": "🌤️",
      "version": "1.0.0",
      "capabilities": ["weather_current", "weather_forecast", "weather_alerts"],
      "configuration": {
        "api_endpoint": "/weather",
        "cache_duration": 300
      },
      "isActive": true,
      "mcpServerUrl": "http://localhost:3001/mcp/weather"
    }
  }
}
```

### Get Profile Capabilities

Get the capabilities supported by a profile.

**Endpoint**: `GET /api/profiles/:profileId/capabilities`

**Parameters**:
- `profileId` (path): Profile identifier

**Headers**:
```
Authorization: Bearer <token>
```

**Response** (200 OK):
```json
{
  "success": true,
  "data": {
    "capabilities": [
      "weather_current",
      "weather_forecast",
      "weather_alerts"
    ]
  }
}
```

## Chat

### Send Message

Send a chat message to an MCP profile.

**Endpoint**: `POST /api/chat`

**Headers**:
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body**:
```json
{
  "message": "What's the weather like today?",
  "profile_id": "weather",
  "conversation_id": "conv_123456" // Optional
}
```

**Validation**:
- `message`: Required, max 5000 characters
- `profile_id`: Required, must be valid profile ID
- `conversation_id`: Optional, for continuing conversations

**Response** (200 OK):
```json
{
  "success": true,
  "data": {
    "response": "Currently it's 72°F with partly cloudy skies...",
    "metadata": {
      "profileId": "weather",
      "timestamp": "2024-01-01T00:00:00.000Z",
      "processingTime": 234
    },
    "conversationId": "conv_123456"
  }
}
```

**Error Response** (400):
```json
{
  "success": false,
  "error": {
    "message": "Validation error",
    "details": [
      {
        "field": "message",
        "message": "\"message\" is required"
      }
    ]
  }
}
```

**Error Response** (500):
```json
{
  "success": false,
  "error": {
    "message": "Failed to process message"
  }
}
```

### Get Conversation History

Retrieve the history of a conversation.

**Endpoint**: `GET /api/chat/history/:conversationId`

**Parameters**:
- `conversationId` (path): Conversation identifier

**Headers**:
```
Authorization: Bearer <token>
```

**Response** (200 OK):
```json
{
  "success": true,
  "data": {
    "conversationId": "conv_123456",
    "messages": [
      {
        "id": "msg_1",
        "role": "user",
        "content": "What's the weather?",
        "timestamp": "2024-01-01T00:00:00.000Z"
      },
      {
        "id": "msg_2",
        "role": "assistant",
        "content": "Currently it's 72°F...",
        "timestamp": "2024-01-01T00:00:01.000Z"
      }
    ]
  }
}
```

## Health Check

### Server Health

Check the health status of the gateway.

**Endpoint**: `GET /health`

**Headers**: None required

**Response** (200 OK):
```json
{
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "uptime": 12345.67
}
```

## Error Codes

| Code | Description |
|------|-------------|
| 200  | Success |
| 400  | Bad Request - Invalid input |
| 401  | Unauthorized - Invalid or missing token |
| 403  | Forbidden - Valid token but insufficient permissions |
| 404  | Not Found - Resource doesn't exist |
| 429  | Too Many Requests - Rate limit exceeded |
| 500  | Internal Server Error |

## Rate Limiting

Rate limits are applied per user and per IP address:

- **Per User**: 100 requests per 15 minutes
- **Per IP**: 1000 requests per hour

When rate limit is exceeded, you'll receive a 429 response:

```json
{
  "success": false,
  "error": {
    "message": "Too many requests from this IP, please try again later."
  }
}
```

## Authentication

All authenticated endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

Tokens expire after 24 hours. Use the refresh endpoint to get a new token.

## Common Response Format

All API responses follow this format:

**Success Response**:
```json
{
  "success": true,
  "data": {
    // Response data
  }
}
```

**Error Response**:
```json
{
  "success": false,
  "error": {
    "message": "Error description",
    "details": [] // Optional, for validation errors
  }
}
```

## Examples

### Example: Complete Chat Flow

```javascript
// 1. Login
const loginResponse = await fetch('http://localhost:3000/api/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    username: 'user@example.com',
    password: 'password123'
  })
});
const { data: { accessToken } } = await loginResponse.json();

// 2. Get profiles
const profilesResponse = await fetch('http://localhost:3000/api/profiles', {
  headers: { 'Authorization': `Bearer ${accessToken}` }
});
const { data: { profiles } } = await profilesResponse.json();

// 3. Send message
const chatResponse = await fetch('http://localhost:3000/api/chat', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${accessToken}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    message: "What's the weather like?",
    profile_id: 'weather'
  })
});
const { data: chatData } = await chatResponse.json();
console.log(chatData.response);
```

## Versioning

Current API version: `v1`

Future versions will be accessible via URL path:
- v1: `/api/...` (current)
- v2: `/api/v2/...` (future)

## Support

For API support, please:
- Check the [documentation](../README.md)
- Open an issue on [GitHub](https://github.com/uilfl/mcp_phone/issues)
- Contact support@mcpphone.example.com
