# Quick Start Guide

Get up and running with MCP Phone in minutes!

## Prerequisites

- **Flutter SDK** 3.0.0+ ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Node.js** 18.x+ ([Install Node.js](https://nodejs.org/))
- **Git** ([Install Git](https://git-scm.com/))
- Android Studio or Xcode (for mobile development)

## 5-Minute Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/uilfl/mcp_phone.git
cd mcp_phone
```

### Step 2: Start the Gateway

```bash
# Navigate to gateway directory
cd gateway

# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Start the server
npm start
```

You should see:
```
MCP Gateway server running on port 3000
Environment: development
```

Keep this terminal open!

### Step 3: Run the Mobile App

Open a **new terminal**:

```bash
# Navigate to mobile app
cd mobile_app

# Install Flutter dependencies
flutter pub get

# Run on Android emulator/device
flutter run

# OR run on iOS simulator (macOS only)
flutter run -d ios
```

### Step 4: Test the App

1. **Login Screen**: Enter any username and password (mock auth)
2. **Profile Selection**: Tap on a profile (Weather, Calendar, etc.)
3. **Chat Screen**: Type a message and send
4. **View Response**: See the assistant's reply

That's it! You now have MCP Phone running locally. 🎉

## What's Next?

### Customize the Gateway

Edit `gateway/.env` to configure:

```bash
# Change the port
PORT=3000

# Set JWT secret (use a strong random string in production)
JWT_SECRET=your-secret-key

# Configure rate limits
RATE_LIMIT_MAX_REQUESTS=100
```

### Explore the Code

**Mobile App Structure:**
```
mobile_app/
├── lib/
│   ├── main.dart          # App entry point
│   ├── screens/           # UI screens
│   ├── services/          # Business logic
│   ├── models/            # Data models
│   └── widgets/           # Reusable components
```

**Gateway Structure:**
```
gateway/
├── src/
│   ├── index.js           # Server entry point
│   ├── routes/            # API endpoints
│   ├── services/          # Business logic
│   └── middleware/        # Express middleware
```

### Add a New Profile

1. Create profile JSON in `profiles/templates/`
2. Add to `gateway/src/services/profileService.js`
3. Add to `mobile_app/lib/services/profile_service.dart`
4. Restart both services

Example profile:

```json
{
  "id": "my-service",
  "name": "My Service",
  "description": "What it does",
  "icon": "🔧",
  "version": "1.0.0",
  "capabilities": ["capability_1", "capability_2"],
  "configuration": {}
}
```

### Connect to Real MCP Servers

Update `gateway/src/services/mcpService.js`:

```javascript
async connectToMCPServer(serverUrl, profileConfig) {
  // Add your MCP server connection logic here
  const client = new MCPClient(serverUrl);
  await client.connect();
  return client;
}
```

## Common Issues

### Gateway won't start

**Port already in use:**
```bash
# Find and kill process using port 3000
lsof -ti:3000 | xargs kill -9

# Or change port in .env
PORT=3001
```

**Missing dependencies:**
```bash
cd gateway
rm -rf node_modules package-lock.json
npm install
```

### Flutter app won't run

**Dependencies not installed:**
```bash
cd mobile_app
flutter clean
flutter pub get
```

**No devices found:**
```bash
# Check available devices
flutter devices

# Start Android emulator
flutter emulators --launch <emulator-id>

# Or iOS simulator (macOS)
open -a Simulator
```

**Build errors:**
```bash
# Clear build cache
flutter clean
rm -rf .dart_tool/
flutter pub get
flutter run
```

## Development Tips

### Hot Reload

- **Flutter**: Press `r` in terminal for hot reload, `R` for hot restart
- **Gateway**: Use `npm run dev` for auto-restart on file changes

### Debugging

**Flutter:**
```bash
# Run with debugging
flutter run --debug

# Enable verbose logging
flutter run --verbose
```

**Gateway:**
```bash
# Run with debugging
NODE_ENV=development node --inspect src/index.js

# View logs
npm start | tee logs.txt
```

### Testing

**Run Flutter tests:**
```bash
cd mobile_app
flutter test
```

**Run Gateway tests:**
```bash
cd gateway
npm test
```

### Code Formatting

**Flutter:**
```bash
# Format code
dart format lib/

# Analyze code
flutter analyze
```

**Gateway:**
```bash
# Lint code
npm run lint

# Auto-fix issues
npm run lint:fix
```

## API Testing

Test the gateway API with curl:

```bash
# Health check
curl http://localhost:3000/health

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test"}'

# Get profiles (replace TOKEN)
curl http://localhost:3000/api/profiles \
  -H "Authorization: Bearer TOKEN"

# Send message
curl -X POST http://localhost:3000/api/chat \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"message":"Hello","profile_id":"weather"}'
```

## Using Docker

**Run gateway in Docker:**

```bash
cd gateway

# Build image
docker build -t mcp-gateway .

# Run container
docker run -p 3000:3000 --env-file .env mcp-gateway

# Or use docker-compose
cd ..
docker-compose up
```

## Resources

- 📖 [Full Documentation](README.md)
- 🏗️ [Architecture Guide](docs/architecture/OVERVIEW.md)
- 🔌 [API Reference](docs/api/README.md)
- 🔒 [Security Guidelines](docs/security/SECURITY.md)
- 🚀 [Deployment Guide](docs/deployment/README.md)
- 🤝 [Contributing Guide](CONTRIBUTING.md)

## Getting Help

- 📝 [GitHub Issues](https://github.com/uilfl/mcp_phone/issues)
- 💬 [GitHub Discussions](https://github.com/uilfl/mcp_phone/discussions)
- 📧 Email: support@mcpphone.example.com

## Next Steps

1. ✅ Complete this quick start
2. 📚 Read the [Architecture Guide](docs/architecture/OVERVIEW.md)
3. 🔧 Customize profiles for your needs
4. 🧪 Add tests for your changes
5. 🚀 Deploy to production
6. 🤝 Contribute back to the project!

---

**Happy coding!** 🚀

If you found this helpful, please ⭐ star the repo!
