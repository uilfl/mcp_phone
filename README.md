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

_Illustrative reference diagrams below; replace with MCP-specific visuals for production documentation._

_Diagram placeholder: Conceptual overview of the MCP ecosystem and its connections, showing the mobile app, gateway, multiple MCP hosts, and isolation boundaries (custom illustration pending)._

_Diagram placeholder: Gateway mediates traffic between the mobile app and multiple MCP hosts, highlighting auth, routing, translation, and rate-limit components (custom illustration pending)._

_Diagram placeholder: End-to-end request/response path enforced by the gateway, including request validation, host call, sanitization, and streamed response back to mobile (custom illustration pending)._

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

_Gateway diagrams are illustrative placeholders; substitute with deployment-specific diagrams when available._

_Diagram placeholder: Gateway layers for routing, auth, throttling, translation, and sanitization, including where policies and quotas are enforced (custom illustration pending)._

_Diagram placeholder: Operational view of the gateway within production stacks, showing ingress, service mesh, observability, and rollback levers (custom illustration pending)._

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

* Gateway rate limiting active
* All MCP Profiles audited
* App Store disclosures approved
* Kill switch tested
* Error states verified

---

## 14) Definition of Success (MVP)

* Users can switch between MCPs in <2 taps
* >=80% requests succeed
* Median latency <5s
* Zero abuse incidents in first cohort

---

## Final Product Definition (One Sentence)

> **A public mobile app that lets users safely choose between multiple curated MCP-powered assistants and interact with them through a simple, transparent chat interface—without ever exposing MCP configuration or control.**
