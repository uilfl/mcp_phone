const { logger } = require('../config/logger');

class ProfileService {
  constructor() {
    // Load profiles from configuration
    this.profiles = this._loadProfiles();
  }

  /**
   * Get all available profiles
   */
  async getAllProfiles() {
    return this.profiles.filter(p => p.isActive);
  }

  /**
   * Get a specific profile by ID
   */
  async getProfile(profileId) {
    return this.profiles.find(p => p.id === profileId);
  }

  /**
   * Get capabilities for a profile
   */
  async getProfileCapabilities(profileId) {
    const profile = await this.getProfile(profileId);
    return profile ? profile.capabilities : [];
  }

  /**
   * Update profile configuration
   */
  async updateProfile(profileId, updates) {
    const index = this.profiles.findIndex(p => p.id === profileId);
    if (index !== -1) {
      this.profiles[index] = { ...this.profiles[index], ...updates };
      logger.info('Profile updated', { profileId });
      return this.profiles[index];
    }
    return null;
  }

  /**
   * Load profiles from configuration
   */
  _loadProfiles() {
    // TODO: Load from database or configuration file
    return [
      {
        id: 'weather',
        name: 'Weather Assistant',
        description: 'Get weather information and forecasts',
        icon: '🌤️',
        version: '1.0.0',
        capabilities: ['weather_current', 'weather_forecast', 'weather_alerts'],
        configuration: {
          api_endpoint: '/weather',
          cache_duration: 300,
        },
        isActive: true,
        mcpServerUrl: 'http://localhost:3001/mcp/weather',
      },
      {
        id: 'calendar',
        name: 'Calendar Manager',
        description: 'Manage your calendar events and reminders',
        icon: '📅',
        version: '1.0.0',
        capabilities: ['calendar_read', 'calendar_write', 'reminders'],
        configuration: {
          api_endpoint: '/calendar',
          sync_enabled: true,
        },
        isActive: true,
        mcpServerUrl: 'http://localhost:3001/mcp/calendar',
      },
      {
        id: 'notes',
        name: 'Notes Assistant',
        description: 'Create and manage your notes',
        icon: '📝',
        version: '1.0.0',
        capabilities: ['notes_create', 'notes_read', 'notes_search'],
        configuration: {
          api_endpoint: '/notes',
          markdown_enabled: true,
        },
        isActive: true,
        mcpServerUrl: 'http://localhost:3001/mcp/notes',
      },
      {
        id: 'tasks',
        name: 'Task Manager',
        description: 'Organize and track your tasks',
        icon: '✅',
        version: '1.0.0',
        capabilities: ['tasks_create', 'tasks_update', 'tasks_complete'],
        configuration: {
          api_endpoint: '/tasks',
          priority_levels: ['low', 'medium', 'high'],
        },
        isActive: true,
        mcpServerUrl: 'http://localhost:3001/mcp/tasks',
      },
    ];
  }
}

module.exports = { ProfileService };
