# MCP Profiles

This directory contains curated MCP profile configurations that define how the mobile app interacts with different MCP services.

## Overview

MCP Profiles are pre-configured service definitions that abstract away the complexity of MCP protocol details from end users. Each profile represents a specific functionality (e.g., weather, calendar) and includes:

- Metadata (name, description, icon)
- Capabilities list
- Configuration settings
- Authentication requirements
- Rate limits
- MCP server connection details

## Directory Structure

```
profiles/
├── schemas/                 # JSON schemas for validation
│   └── profile-schema.json # Profile structure definition
└── templates/              # Profile templates
    ├── weather-profile.json
    ├── calendar-profile.json
    ├── notes-profile.json
    └── tasks-profile.json
```

## Profile Schema

All profiles must conform to the JSON schema defined in `schemas/profile-schema.json`.

### Required Fields

- `id`: Unique identifier (lowercase, alphanumeric, dashes/underscores)
- `name`: Display name
- `description`: Brief description
- `version`: Semantic version (e.g., "1.0.0")
- `capabilities`: Array of capability identifiers

### Optional Fields

- `icon`: Emoji or icon identifier
- `configuration`: Profile-specific settings
- `isActive`: Whether profile is available (default: true)
- `mcpServerUrl`: URL of the MCP server
- `authentication`: Authentication configuration
- `rateLimits`: Rate limiting configuration
- `metadata`: Additional metadata

## Creating a New Profile

### Step 1: Create Profile JSON

Create a new JSON file in `templates/`:

```json
{
  "id": "my-service",
  "name": "My Service",
  "description": "Description of what this service does",
  "icon": "🔧",
  "version": "1.0.0",
  "capabilities": [
    "my_capability_1",
    "my_capability_2"
  ],
  "configuration": {
    "api_endpoint": "/my-service",
    "custom_setting": "value"
  },
  "isActive": true,
  "mcpServerUrl": "http://localhost:3001/mcp/my-service",
  "authentication": {
    "type": "bearer",
    "required": true
  },
  "rateLimits": {
    "requestsPerMinute": 60,
    "requestsPerHour": 1000
  },
  "metadata": {
    "author": "Your Name",
    "homepage": "https://example.com",
    "license": "MIT",
    "tags": ["tag1", "tag2"]
  }
}
```

### Step 2: Validate Profile

Validate your profile against the schema:

```bash
# Using a JSON schema validator
ajv validate -s schemas/profile-schema.json -d templates/my-service-profile.json
```

### Step 3: Add to Gateway

Add your profile to the gateway's profile service:

```javascript
// gateway/src/services/profileService.js
_loadProfiles() {
  return [
    // ... existing profiles
    {
      id: 'my-service',
      name: 'My Service',
      // ... rest of your profile
    }
  ];
}
```

### Step 4: Test Profile

1. Start the gateway server
2. Authenticate with the mobile app
3. Navigate to the Profiles screen
4. Verify your profile appears and is selectable
5. Test sending messages to your profile

## Available Profiles

### Weather Assistant

- **ID**: `weather`
- **Capabilities**: Current weather, forecasts, alerts
- **Use Cases**: Check weather, get forecasts, weather alerts

### Calendar Manager

- **ID**: `calendar`
- **Capabilities**: Read/write events, reminders
- **Use Cases**: Schedule events, set reminders, view calendar

### Notes Assistant

- **ID**: `notes`
- **Capabilities**: Create, read, search notes
- **Use Cases**: Take notes, organize information, search notes

### Task Manager

- **ID**: `tasks`
- **Capabilities**: Create, update, complete tasks
- **Use Cases**: Manage tasks, track progress, set priorities

## Capability Naming Convention

Capabilities should follow this pattern:

```
<resource>_<action>
```

Examples:
- `weather_current` - Get current weather
- `calendar_read` - Read calendar events
- `notes_create` - Create a new note
- `tasks_update` - Update a task

Common actions:
- `create` - Create new resource
- `read` - Read/retrieve resource
- `update` - Update existing resource
- `delete` - Delete resource
- `list` - List multiple resources
- `search` - Search resources

## Authentication Types

- `none`: No authentication required
- `api_key`: API key authentication
- `bearer`: Bearer token authentication
- `oauth2`: OAuth 2.0 authentication

## Rate Limiting

Recommended rate limits:

- **Light usage**: 60 req/min, 1000 req/hour
- **Medium usage**: 120 req/min, 5000 req/hour
- **Heavy usage**: 300 req/min, 10000 req/hour

Adjust based on:
- MCP server capacity
- User tier/plan
- Resource intensity
- Cost considerations

## Profile Versioning

Follow semantic versioning (semver):

- **Major** (X.0.0): Breaking changes
- **Minor** (0.X.0): New features, backwards compatible
- **Patch** (0.0.X): Bug fixes, backwards compatible

Example version history:
- `1.0.0`: Initial release
- `1.1.0`: Added new capability
- `1.1.1`: Fixed bug in capability
- `2.0.0`: Changed capability interface (breaking)

## Best Practices

### Profile Design

1. **Single Responsibility**: One profile per service domain
2. **Clear Naming**: Use descriptive, user-friendly names
3. **Appropriate Icons**: Choose relevant, recognizable emojis
4. **Comprehensive Descriptions**: Explain what the profile does
5. **Minimal Configuration**: Keep configuration simple

### Capability Design

1. **Atomic Operations**: Each capability should do one thing
2. **Clear Names**: Use descriptive, action-based names
3. **Consistent Patterns**: Follow naming conventions
4. **Well-Documented**: Document inputs and outputs

### Security

1. **Least Privilege**: Only request necessary permissions
2. **Secure Defaults**: Default to secure settings
3. **Validate Configuration**: Validate all config values
4. **Rate Limiting**: Set appropriate rate limits
5. **Authentication**: Use strongest auth method available

## Testing Profiles

### Manual Testing

1. Load profile in mobile app
2. Verify profile metadata displays correctly
3. Test each capability
4. Verify error handling
5. Test rate limiting
6. Test authentication flow

### Automated Testing

```javascript
// Example test
describe('Profile: Weather', () => {
  it('should have valid schema', () => {
    const profile = require('../templates/weather-profile.json');
    expect(validate(profile)).toBe(true);
  });

  it('should have all required fields', () => {
    const profile = require('../templates/weather-profile.json');
    expect(profile.id).toBeDefined();
    expect(profile.name).toBeDefined();
    expect(profile.capabilities).toBeInstanceOf(Array);
  });
});
```

## Troubleshooting

### Profile Not Appearing

1. Check JSON syntax
2. Verify schema validation
3. Ensure profile is added to gateway
4. Check `isActive` flag
5. Restart gateway server

### Capability Not Working

1. Verify capability name
2. Check MCP server connection
3. Review authentication
4. Check rate limits
5. Review error logs

### Authentication Failing

1. Verify auth type configuration
2. Check credentials
3. Review token expiration
4. Check MCP server auth requirements

## Contributing

To contribute a new profile:

1. Create profile JSON following schema
2. Test thoroughly
3. Document capabilities
4. Submit pull request
5. Include test cases

## Resources

- [MCP Protocol Specification](https://github.com/modelcontextprotocol/specification)
- [JSON Schema](https://json-schema.org/)
- [Semantic Versioning](https://semver.org/)

## Support

For profile-related questions:
- GitHub Issues
- Documentation
- Community Forum

---

**Last Updated**: 2024-01-01
