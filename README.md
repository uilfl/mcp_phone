# Comprehensive Build Document

**Product:** Public Multi-MCP Mobile Interface  
**Platforms:** Android & iOS  
**Status:** Public MVP (read-only, curated)

---

## 1) Product Scope & Non-Goals

### In Scope (MVP)

* Multi-MCP **profile selection**
* Chat-based interaction
* Streaming responses
* Read-only tools
* Card-based UI rendering
* Anonymous users (device-bound)

### Explicit Non-Goals (MVP)

* User-defined MCP servers
* Tool execution with side effects
* Cross-MCP memory
* Background jobs / push notifications
* Advanced visualizations

**Acceptance:** Any feature not listed above is deferred.

---

## 2) System Architecture

![Conceptual overview of the MCP ecosystem and its connections](https://cdn.analyticsvidhya.com/wp-content/uploads/2025/04/Understanding-MCP.webp?utm_source=chatgpt.com)

*Figure: High-level MCP ecosystem showing how components interconnect.*

![AI gateway-centric MCP architecture showing mobile, gateway, and hosts](https://mintcdn.com/truefoundry/-g83eZw0cKb4T5XU/images/docs/ai-gateway-mcp-architecture.png?auto=format&fit=max&n=-g83eZw0cKb4T5XU&q=85&s=ec9528496c8775161809b19afc74899e&utm_source=chatgpt.com)

*Figure: Gateway mediates traffic between the mobile app and multiple MCP hosts.*

![Sequence of MCP request and response flow with intermediary gateway](https://miro.medium.com/v2/resize%3Afit%3A1400/1%2A7Kfh76Y2ONwbYLpIfOHtVQ.png?utm_source=chatgpt.com)

*Figure: End-to-end request/response path enforced by the gateway.*

### Components

1. **Mobile App (Flutter)**
   * UI, session state, rendering
2. **MCP Gateway**
   * Auth, routing, translation, rate limits
3. **MCP Hosts**
   * One per MCP Profile (or shared with strict configs)

### Data Flow

```
Mobile → Gateway → MCP Host → Gateway → Mobile
```

**Invariant:** Mobile never connects to MCP directly.

---

## 3) MCP Profiles (Core Concept)

### Definition

An **MCP Profile** is a server-side, immutable configuration that maps a user-friendly assistant to a controlled MCP environment.

### Minimum Schema

```json
{
  "id": "general_readonly",
  "name": "General Assistant",
  "description": "General-purpose explanations and summaries",
  "icon": "spark",
  "status": "public",
  "limits": {
    "rpm": 20,
    "tokens_per_day": 20000
  },
  "capabilities": ["read", "summarize"]
}
```

### Rules

* Profiles are **curated**
* Profiles are **versioned**
* Profiles are **kill-switchable**

---

## 4) Mobile App Build (Flutter)

### Screens (MVP = 3)

1. **MCP Selector**
   * List of profiles
   * Name, description, icon
2. **Chat Screen**
   * Message list
   * Streaming responses
   * “Agent is working” indicator
3. **Info / About**
   * AI disclosure
   * Usage limits
   * Privacy note

### State Management

* In-memory sessions only
* One session per MCP Profile

### UI Primitives Supported

* Plain text (Markdown)
* Simple cards (title + content)

### Out of Scope

* Login
* Offline mode
* Tool trace viewer

---

## 5) Gateway Responsibilities (Critical)

![Gateway request handling pipeline with policy enforcement](https://www.atatus.com/blog/content/images/2022/09/api-gateway.png?utm_source=chatgpt.com)

*Figure: Gateway layers for routing, auth, and throttling.*

![Gateway deployment diagram with ingress, services, and observability](https://i0.wp.com/www.phdata.io/wp-content/uploads/2024/10/article-image1-1.png?utm_source=chatgpt.com)

*Figure: Operational view of the gateway in production stacks.*

### Mandatory Functions

* Device token issuance
* Rate limiting (per device × MCP)
* MCP Profile validation
* Request translation
* Response sanitization

### Forbidden Functions

* Agent logic
* Tool decisions
* Memory management

### Suggested Stack

* FastAPI / Node.js
* HTTPS only
* Stateless

---

## 6) API Contracts

### Request (Mobile → Gateway)

```json
{
  "session_id": "uuid",
  "mcp_profile_id": "general_readonly",
  "input": "Explain MCP in simple terms",
  "context": {
    "device": "mobile",
    "locale": "en"
  }
}
```

### Response (Gateway → Mobile)

```json
{
  "type": "text",
  "content": "MCP lets AI models access tools safely..."
}
```

### Error Contract

```json
{
  "error": "rate_limited",
  "message": "Please wait before sending another message."
}
```

---

## 7) Tool & Output Design

### Tool Policy

* Read-only tools only
* No side effects
* Hard allowlist per MCP Profile

### Output Policy

* Tools return **structured JSON**
* Gateway converts to UI-safe schemas
* No raw logs or stack traces

**Supported Output Types**

* `text`
* `card`

---

## 8) Security Model

### Identity

* Anonymous
* Device-bound token
* No PII required

### Protections

* Per-profile rate limits
* Token quotas
* Prompt sanitization
* Output filtering

### Kill Switches

* Disable profile
* Block device
* Reduce rate limits

---

## 9) Failure & Resilience

### Expected Failures

* MCP timeout
* Rate limit exceeded
* Network loss

### User Experience

* Clear error messages
* Retry guidance
* No silent failure

### Observability

* Request count
* Error rate
* Median latency

---

## 10) App Store & Compliance

### Required Disclosures

* AI-generated content notice
* No human guarantee
* Data usage explanation

### Compliance Strategy

* No executable code
* No hidden behavior
* No personal data dependency

---

## 11) Deployment & Ops

### Environments

* Dev
* Staging
* Production

### CI/CD

* Automated builds (Flutter)
* Gateway deploy via container
* Config-driven MCP Profiles

### Rollback

* Disable MCP Profile
* Gateway version rollback

---

## 12) Cost & Limits (MVP Defaults)

### Per MCP Profile

* RPM: 20
* Tokens/day/device: 20k

### Global

* Max MCP Profiles: 5
* Max sessions/device: 5

---

## 13) Launch Checklist

### Must Be True Before Public Release

* [ ] Gateway rate limiting active
* [ ] All MCP Profiles audited
* [ ] App Store disclosures approved
* [ ] Kill switch tested
* [ ] Error states verified

---

## 14) Definition of Success (MVP)

* Users can switch MCPs in <2 taps
* ≥80% requests succeed
* Median latency <5s
* Zero abuse incidents in first cohort

---

## Final Product Definition (One Sentence)

> **A public mobile app that lets users safely choose between multiple curated MCP-powered assistants and interact with them through a simple, transparent chat interface—without ever exposing MCP configuration or control.**
