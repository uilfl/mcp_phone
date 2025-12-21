# System Architecture Diagram

## High-Level Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                         User Layer                               │
│  ┌──────────────┐                        ┌──────────────┐       │
│  │   Android    │                        │     iOS      │       │
│  │   Device     │                        │    Device    │       │
│  └──────┬───────┘                        └──────┬───────┘       │
└─────────┼──────────────────────────────────────┼────────────────┘
          │                                       │
          │         HTTPS + JWT Auth             │
          │                                       │
┌─────────▼───────────────────────────────────────▼────────────────┐
│                    Application Layer                             │
│  ┌────────────────────────────────────────────────────────┐     │
│  │              MCP Gateway (Node.js)                     │     │
│  │  ┌──────────────────────────────────────────────────┐ │     │
│  │  │        API Layer                                 │ │     │
│  │  │  - Authentication (JWT)                          │ │     │
│  │  │  - Authorization                                 │ │     │
│  │  │  - Rate Limiting                                 │ │     │
│  │  │  - Input Validation                              │ │     │
│  │  │  - Request Routing                               │ │     │
│  │  └──────────────────────────────────────────────────┘ │     │
│  │  ┌──────────────────────────────────────────────────┐ │     │
│  │  │        Business Logic Layer                      │ │     │
│  │  │  - Profile Management                            │ │     │
│  │  │  - Message Processing                            │ │     │
│  │  │  - MCP Protocol Handling                         │ │     │
│  │  │  - Response Transformation                       │ │     │
│  │  └──────────────────────────────────────────────────┘ │     │
│  └────────────────────────────────────────────────────────┘     │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             │ MCP Protocol
                             │
┌────────────────────────────▼─────────────────────────────────────┐
│                    Integration Layer                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │ Weather  │  │ Calendar │  │  Notes   │  │  Tasks   │        │
│  │   MCP    │  │   MCP    │  │   MCP    │  │   MCP    │        │
│  │  Server  │  │  Server  │  │  Server  │  │  Server  │        │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘        │
└──────────────────────────────────────────────────────────────────┘
```

## Component Interaction Flow

```
User Action → Mobile App → Gateway → MCP Server → Response Flow

1. USER INITIATES ACTION
   └─> Taps on Weather profile
   └─> Types "What's the weather?"
   └─> Presses send

2. MOBILE APP PROCESSES
   └─> Validates input locally
   └─> Adds authentication token
   └─> Sends HTTPS POST to gateway
   └─> Shows loading indicator

3. GATEWAY RECEIVES REQUEST
   └─> Verifies JWT token
   └─> Checks rate limits
   └─> Validates input schema
   └─> Routes to profile handler
   └─> Logs request

4. MCP SERVICE LAYER
   └─> Identifies profile (weather)
   └─> Connects to MCP server
   └─> Sends MCP protocol request
   └─> Receives MCP response
   └─> Transforms to mobile format

5. GATEWAY SENDS RESPONSE
   └─> Formats response
   └─> Adds metadata
   └─> Returns JSON to mobile
   └─> Logs response

6. MOBILE APP DISPLAYS
   └─> Parses response
   └─> Updates UI
   └─> Shows message bubble
   └─> Hides loading indicator
```

## Security Layers

```
┌─────────────────────────────────────────────────────────┐
│ Layer 1: Transport Security                            │
│  - HTTPS/TLS 1.3                                       │
│  - Certificate Pinning (future)                        │
└─────────────────────────────────────────────────────────┘
                        │
┌─────────────────────────────────────────────────────────┐
│ Layer 2: Authentication                                │
│  - JWT Token Verification                              │
│  - Token Expiration (24h)                              │
│  - Refresh Token Mechanism                             │
└─────────────────────────────────────────────────────────┘
                        │
┌─────────────────────────────────────────────────────────┐
│ Layer 3: Authorization                                 │
│  - User Permission Checks                              │
│  - Profile Access Control                              │
│  - Role-Based Access (future)                          │
└─────────────────────────────────────────────────────────┘
                        │
┌─────────────────────────────────────────────────────────┐
│ Layer 4: Input Validation                              │
│  - Schema Validation (Joi)                             │
│  - Type Checking                                       │
│  - Length Limits                                       │
│  - Sanitization                                        │
└─────────────────────────────────────────────────────────┘
                        │
┌─────────────────────────────────────────────────────────┐
│ Layer 5: Rate Limiting                                 │
│  - Per-User Limits                                     │
│  - Per-IP Limits                                       │
│  - Per-Endpoint Limits                                 │
└─────────────────────────────────────────────────────────┘
                        │
┌─────────────────────────────────────────────────────────┐
│ Layer 6: Business Logic                                │
│  - Profile Permissions                                 │
│  - Capability Checks                                   │
│  - Data Access Controls                                │
└─────────────────────────────────────────────────────────┘
```

## Data Flow Diagram

```
┌────────────┐     ┌────────────┐     ┌────────────┐
│   Mobile   │────>│  Gateway   │────>│    MCP     │
│    App     │     │   Server   │     │   Server   │
└────────────┘     └────────────┘     └────────────┘
      │                  │                   │
      │                  │                   │
      │  1. User Input   │                   │
      │─────────────────>│                   │
      │                  │                   │
      │                  │  2. MCP Request   │
      │                  │──────────────────>│
      │                  │                   │
      │                  │  3. MCP Response  │
      │                  │<──────────────────│
      │                  │                   │
      │  4. User Display │                   │
      │<─────────────────│                   │
      │                  │                   │
```

## Deployment Architecture

### Development Environment

```
┌──────────────────────────────────────────┐
│         Developer Machine                │
│                                          │
│  ┌────────────┐      ┌────────────┐    │
│  │  Flutter   │      │  Gateway   │    │
│  │    App     │<────>│ localhost  │    │
│  │ (Emulator) │      │   :3000    │    │
│  └────────────┘      └────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐  │
│  │      Mock MCP Servers            │  │
│  └──────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

### Production Environment

```
┌─────────────────────────────────────────────────────────┐
│                    Cloud Infrastructure                 │
│                                                         │
│  ┌────────────┐                                        │
│  │    CDN     │ (Static Assets)                        │
│  └─────┬──────┘                                        │
│        │                                                │
│  ┌─────▼──────────┐                                    │
│  │ Load Balancer  │ (HTTPS Termination)                │
│  └─────┬──────────┘                                    │
│        │                                                │
│  ┌─────▼─────────────────────────────┐                │
│  │    Gateway Cluster (Auto-scaled)  │                │
│  │  ┌──────┐  ┌──────┐  ┌──────┐    │                │
│  │  │ GW 1 │  │ GW 2 │  │ GW 3 │    │                │
│  │  └──────┘  └──────┘  └──────┘    │                │
│  └───────────────┬───────────────────┘                │
│                  │                                      │
│  ┌───────────────▼───────────────────┐                │
│  │      Database Cluster             │                │
│  │  (Sessions, Profiles, History)    │                │
│  └───────────────────────────────────┘                │
│                                                         │
│  ┌─────────────────────────────────────────┐          │
│  │         External MCP Servers            │          │
│  │  (Weather, Calendar, Notes, Tasks)      │          │
│  └─────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│              Mobile Distribution                        │
│  ┌──────────────┐         ┌──────────────┐            │
│  │  Apple App   │         │  Google Play │            │
│  │    Store     │         │    Store     │            │
│  └──────────────┘         └──────────────┘            │
└─────────────────────────────────────────────────────────┘
```

## Technology Stack

```
┌─────────────────────────────────────────────────────────┐
│                    Mobile Layer                         │
│  - Flutter 3.x (Dart)                                  │
│  - Provider (State Management)                          │
│  - flutter_secure_storage (Credentials)                │
│  - http (API Client)                                    │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                   Gateway Layer                         │
│  - Node.js 18.x                                        │
│  - Express.js 4.x (Web Framework)                      │
│  - JWT (Authentication)                                 │
│  - Helmet.js (Security Headers)                         │
│  - Winston (Logging)                                    │
│  - Joi (Validation)                                     │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                  Infrastructure Layer                   │
│  - Docker (Containerization)                           │
│  - Nginx (Reverse Proxy)                               │
│  - Let's Encrypt (SSL Certificates)                    │
│  - PM2 (Process Management)                            │
└─────────────────────────────────────────────────────────┘
```

---

**Last Updated**: 2024-01-01
