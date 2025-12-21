# MCP Phone - Multi-MCP Mobile Application

A secure, scalable mobile application for Android and iOS that enables users to interact with multiple MCP (Model Context Protocol) services through curated profiles.

## 🎯 Executive Summary

MCP Phone is designed to ship a **public, multi-MCP mobile app** safely and quickly by building three parallel components:

1. **Flutter Mobile Client** - Cross-platform mobile app (Android & iOS)
2. **Secure MCP Gateway** - Backend API that manages MCP connections
3. **Curated MCP Profiles** - Pre-configured service profiles for users

The application deliberately **does not expose MCP internals** to users, providing a simplified, secure interface instead.

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Development](#development)
- [Deployment](#deployment)
- [Security](#security)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

### Mobile Client
- 📱 Cross-platform support (Android & iOS)
- 💬 Chat interface for MCP interactions
- 🎨 Material Design 3 UI
- 🔐 Secure authentication
- 📊 Profile management
- 🌙 Dark mode support (coming soon)
- 📴 Offline capabilities (coming soon)

### MCP Gateway
- 🔒 Secure API with JWT authentication
- 🛡️ Rate limiting and request validation
- 📝 Comprehensive logging
- 🔄 Request/response transformation
- ⚡ High performance with connection pooling
- 🎯 Profile-based routing

### MCP Profiles
- 🌤️ Weather Assistant
- 📅 Calendar Manager
- 📝 Notes Assistant
- ✅ Task Manager
- 🔌 Extensible profile system

## 🏗️ Architecture

```
┌─────────────────┐
│  Mobile Client  │  Flutter (Android/iOS)
│   (Flutter)     │
└────────┬────────┘
         │ HTTPS
         │ JWT Auth
         │
┌────────▼────────┐
│  MCP Gateway    │  Node.js/Express
│   (Backend)     │  - Authentication
│                 │  - Rate Limiting
│                 │  - Request Validation
└────────┬────────┘
         │
         │ MCP Protocol
         │
┌────────▼────────┐
│  MCP Services   │  Various MCP Servers
│   (External)    │  - Weather
│                 │  - Calendar
│                 │  - Notes, etc.
└─────────────────┘
```

### Key Design Principles

1. **Security First**: All communication is encrypted, authenticated, and validated
2. **User Privacy**: MCP internals are abstracted away from users
3. **Scalability**: Stateless architecture allows horizontal scaling
4. **Reliability**: Error handling, retry logic, and graceful degradation
5. **Maintainability**: Clean code, comprehensive tests, and documentation

## 📁 Project Structure

```
mcp_phone/
├── mobile_app/              # Flutter mobile application
│   ├── lib/
│   │   ├── main.dart       # Application entry point
│   │   ├── models/         # Data models
│   │   ├── screens/        # UI screens
│   │   ├── services/       # Business logic
│   │   ├── widgets/        # Reusable UI components
│   │   └── utils/          # Utility functions
│   ├── test/               # Unit and widget tests
│   └── pubspec.yaml        # Flutter dependencies
│
├── gateway/                # MCP Gateway backend
│   ├── src/
│   │   ├── index.js        # Server entry point
│   │   ├── config/         # Configuration
│   │   ├── middleware/     # Express middleware
│   │   ├── routes/         # API routes
│   │   ├── services/       # Business logic
│   │   └── models/         # Data models
│   ├── tests/              # Backend tests
│   └── package.json        # Node.js dependencies
│
├── profiles/               # MCP Profile configurations
│   ├── schemas/            # JSON schemas for validation
│   └── templates/          # Profile templates
│
└── docs/                   # Documentation
    ├── architecture/       # Architecture documentation
    ├── api/               # API documentation
    ├── deployment/        # Deployment guides
    └── security/          # Security documentation
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (3.0.0 or higher)
- **Node.js** (18.x or higher)
- **npm** or **yarn**
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/uilfl/mcp_phone.git
cd mcp_phone
```

2. **Setup Mobile App**
```bash
cd mobile_app
flutter pub get
flutter run
```

3. **Setup Gateway**
```bash
cd gateway
npm install
cp .env.example .env
# Edit .env with your configuration
npm start
```

## 💻 Development

### Mobile App Development

```bash
cd mobile_app

# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Run tests
flutter test

# Build for production
flutter build apk          # Android
flutter build ios          # iOS
```

### Gateway Development

```bash
cd gateway

# Development mode with hot reload
npm run dev

# Run tests
npm test

# Lint code
npm run lint
npm run lint:fix

# Production build
npm start
```

### Code Style

- **Flutter**: Follow [Flutter style guide](https://dart.dev/guides/language/effective-dart/style)
- **Node.js**: Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)

## 🚢 Deployment

See detailed deployment guides in [`docs/deployment/`](docs/deployment/):

- [Mobile App Deployment](docs/deployment/MOBILE_DEPLOYMENT.md)
- [Gateway Deployment](docs/deployment/GATEWAY_DEPLOYMENT.md)
- [Docker Deployment](docs/deployment/DOCKER_DEPLOYMENT.md)

### Quick Deploy (Gateway)

```bash
cd gateway
docker build -t mcp-gateway .
docker run -p 3000:3000 --env-file .env mcp-gateway
```

## 🔒 Security

Security is a top priority. Key security features:

- **JWT Authentication**: Secure token-based authentication
- **HTTPS Only**: All communication encrypted
- **Rate Limiting**: Prevent abuse and DDoS
- **Input Validation**: All inputs validated and sanitized
- **Secure Storage**: Credentials stored in secure storage
- **CORS Protection**: Controlled cross-origin requests
- **Security Headers**: Helmet.js for security headers

For more details, see [Security Documentation](docs/security/SECURITY.md).

## 📚 Documentation

- [Architecture Overview](docs/architecture/OVERVIEW.md)
- [API Reference](docs/api/README.md)
- [Security Guidelines](docs/security/SECURITY.md)
- [Deployment Guide](docs/deployment/README.md)
- [Profile Development](profiles/README.md)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- MCP Protocol Specification
- Flutter Team
- Express.js Community

## 📞 Contact

- GitHub Issues: [https://github.com/uilfl/mcp_phone/issues](https://github.com/uilfl/mcp_phone/issues)
- Email: support@mcpphone.example.com

---

**Built with ❤️ for the MCP community**
