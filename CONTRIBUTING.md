# Contributing to MCP Phone

Thank you for your interest in contributing to MCP Phone! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Guidelines](#issue-guidelines)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for everyone. We expect all contributors to:

- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards others

### Unacceptable Behavior

- Harassment or discriminatory language
- Personal attacks or trolling
- Public or private harassment
- Publishing others' private information
- Other conduct inappropriate in a professional setting

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- Git installed and configured
- GitHub account
- Development environment set up (see [Development Setup](#development-setup))
- Basic knowledge of Flutter/Dart (for mobile) or Node.js (for backend)

### Finding Issues to Work On

Good ways to start:

1. **Good First Issues**: Look for issues labeled `good first issue`
2. **Help Wanted**: Issues labeled `help wanted` need community assistance
3. **Documentation**: Improvements to docs are always welcome
4. **Bug Fixes**: Check open bug reports

## Development Setup

### Mobile App Setup

```bash
# Clone repository
git clone https://github.com/uilfl/mcp_phone.git
cd mcp_phone/mobile_app

# Install dependencies
flutter pub get

# Run on emulator/device
flutter run

# Run tests
flutter test
```

### Gateway Setup

```bash
# Navigate to gateway
cd mcp_phone/gateway

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Start development server
npm run dev

# Run tests
npm test
```

## How to Contribute

### Reporting Bugs

Before creating a bug report:

1. Check existing issues to avoid duplicates
2. Collect relevant information:
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, versions, etc.)
   - Screenshots or logs if applicable

Create bug report:

```markdown
**Description**
Brief description of the bug

**To Reproduce**
1. Step 1
2. Step 2
3. ...

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- OS: [e.g., iOS 17, Android 13]
- App Version: [e.g., 1.0.0]
- Device: [e.g., iPhone 14, Pixel 7]

**Additional Context**
Screenshots, logs, etc.
```

### Suggesting Features

For feature requests:

1. Check if similar feature exists or was requested
2. Describe the problem the feature solves
3. Explain your proposed solution
4. Consider alternative solutions

Feature request template:

```markdown
**Problem**
Clear description of the problem

**Proposed Solution**
Your suggested implementation

**Alternatives Considered**
Other approaches you've thought about

**Additional Context**
Any other relevant information
```

### Contributing Code

#### 1. Fork and Clone

```bash
# Fork on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/mcp_phone.git
cd mcp_phone

# Add upstream remote
git remote add upstream https://github.com/uilfl/mcp_phone.git
```

#### 2. Create a Branch

```bash
# Update main branch
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Test additions or fixes

#### 3. Make Changes

- Write clear, concise code
- Follow coding standards (see below)
- Add tests for new functionality
- Update documentation as needed
- Keep commits focused and atomic

#### 4. Commit Changes

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "feat: add profile caching

- Implement in-memory cache for profiles
- Add cache invalidation logic
- Update tests"
```

Commit message format:
```
<type>: <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

#### 5. Push and Create PR

```bash
# Push to your fork
git push origin feature/your-feature-name

# Create Pull Request on GitHub
```

## Coding Standards

### Flutter/Dart Standards

Follow [Effective Dart](https://dart.dev/guides/language/effective-dart):

```dart
// Good
class UserProfile {
  final String id;
  final String name;
  
  UserProfile({required this.id, required this.name});
  
  /// Creates a profile from JSON data
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

// Use meaningful variable names
final userProfile = UserProfile.fromJson(data);

// Add documentation for public APIs
/// Fetches user profile from the server.
/// 
/// Returns [UserProfile] if successful, null otherwise.
Future<UserProfile?> fetchUserProfile(String userId) async {
  // Implementation
}
```

### Node.js Standards

Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript):

```javascript
// Good
class ProfileService {
  constructor() {
    this.profiles = [];
  }
  
  /**
   * Get all active profiles
   * @returns {Array<Profile>} List of active profiles
   */
  async getAllProfiles() {
    return this.profiles.filter(p => p.isActive);
  }
}

// Use async/await
async function fetchProfile(id) {
  try {
    const profile = await profileService.getProfile(id);
    return profile;
  } catch (error) {
    logger.error('Failed to fetch profile:', error);
    throw error;
  }
}

// Use const/let, not var
const maxRetries = 3;
let currentAttempt = 0;
```

### General Guidelines

- Use meaningful variable and function names
- Keep functions small and focused
- Add comments for complex logic
- Avoid deep nesting
- Handle errors appropriately
- Don't commit commented-out code
- Remove console.logs before committing

## Testing Guidelines

### Flutter Tests

```dart
// Widget test example
testWidgets('Profile card displays correctly', (WidgetTester tester) async {
  final profile = MCPProfile(
    id: 'test',
    name: 'Test Profile',
    // ...
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: ProfileCard(profile: profile),
    ),
  );
  
  expect(find.text('Test Profile'), findsOneWidget);
});

// Unit test example
test('UserSession.isExpired returns true for expired session', () {
  final session = UserSession(
    userId: 'test',
    accessToken: 'token',
    expiresAt: DateTime.now().subtract(Duration(hours: 1)),
  );
  
  expect(session.isExpired, isTrue);
});
```

### Node.js Tests

```javascript
// API test example
describe('GET /api/profiles', () => {
  it('should return list of profiles', async () => {
    const response = await request(app)
      .get('/api/profiles')
      .set('Authorization', `Bearer ${token}`)
      .expect(200);
    
    expect(response.body.success).toBe(true);
    expect(response.body.data.profiles).toBeInstanceOf(Array);
  });
});

// Service test example
describe('ProfileService', () => {
  it('should get profile by id', async () => {
    const service = new ProfileService();
    const profile = await service.getProfile('weather');
    
    expect(profile).toBeDefined();
    expect(profile.id).toBe('weather');
  });
});
```

### Test Requirements

- Write tests for new features
- Maintain or improve code coverage
- Test edge cases and error conditions
- Run full test suite before submitting PR
- Fix any failing tests

## Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] Commit messages are clear
- [ ] No merge conflicts
- [ ] Code is properly formatted

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Changes Made
- Change 1
- Change 2
- ...

## Testing
How to test these changes

## Screenshots (if applicable)
Add screenshots here

## Checklist
- [ ] Tests pass
- [ ] Documentation updated
- [ ] Code follows style guide
- [ ] No console.logs or debug code
```

### Review Process

1. Automated checks must pass (linting, tests)
2. At least one maintainer review required
3. Address review comments
4. Maintain discussion in PR, not external channels
5. Once approved, maintainer will merge

### After Merge

- Delete your feature branch
- Update your local repository
- Close related issues

## Issue Guidelines

### Creating Issues

Use templates when available:
- Bug Report
- Feature Request
- Documentation Improvement

### Issue Labels

Common labels:
- `bug` - Something isn't working
- `enhancement` - New feature request
- `documentation` - Documentation improvements
- `good first issue` - Good for newcomers
- `help wanted` - Community help needed
- `question` - Questions about the project
- `wontfix` - Not planned to be addressed

## Community

### Getting Help

- GitHub Discussions
- Issue tracker
- Documentation

### Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Credited in release notes
- Eligible for contributor badge

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

Don't hesitate to ask! Open an issue or reach out to maintainers.

Thank you for contributing to MCP Phone! 🎉

---

**Last Updated**: 2024-01-01
