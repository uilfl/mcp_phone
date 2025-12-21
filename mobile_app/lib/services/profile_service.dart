import 'package:flutter/foundation.dart';
import '../models/mcp_profile.dart';
import 'dart:convert';

/// Manages MCP profiles and their configurations
class ProfileService extends ChangeNotifier {
  List<MCPProfile> _profiles = [];
  MCPProfile? _selectedProfile;
  bool _isLoading = false;

  List<MCPProfile> get profiles => List.unmodifiable(_profiles);
  MCPProfile? get selectedProfile => _selectedProfile;
  bool get isLoading => _isLoading;

  ProfileService() {
    _loadProfiles();
  }

  /// Load available MCP profiles
  Future<void> _loadProfiles() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Load profiles from MCP Gateway or local storage
      // For now, create mock profiles
      _profiles = _getMockProfiles();
      
      if (_profiles.isNotEmpty && _selectedProfile == null) {
        _selectedProfile = _profiles.first;
      }
    } catch (e) {
      debugPrint('Error loading profiles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get mock profiles for demonstration
  List<MCPProfile> _getMockProfiles() {
    return [
      MCPProfile(
        id: 'weather',
        name: 'Weather Assistant',
        description: 'Get weather information and forecasts',
        icon: '🌤️',
        version: '1.0.0',
        capabilities: ['weather_current', 'weather_forecast', 'weather_alerts'],
        configuration: {
          'api_endpoint': '/weather',
          'cache_duration': 300,
        },
      ),
      MCPProfile(
        id: 'calendar',
        name: 'Calendar Manager',
        description: 'Manage your calendar events and reminders',
        icon: '📅',
        version: '1.0.0',
        capabilities: ['calendar_read', 'calendar_write', 'reminders'],
        configuration: {
          'api_endpoint': '/calendar',
          'sync_enabled': true,
        },
      ),
      MCPProfile(
        id: 'notes',
        name: 'Notes Assistant',
        description: 'Create and manage your notes',
        icon: '📝',
        version: '1.0.0',
        capabilities: ['notes_create', 'notes_read', 'notes_search'],
        configuration: {
          'api_endpoint': '/notes',
          'markdown_enabled': true,
        },
      ),
      MCPProfile(
        id: 'tasks',
        name: 'Task Manager',
        description: 'Organize and track your tasks',
        icon: '✅',
        version: '1.0.0',
        capabilities: ['tasks_create', 'tasks_update', 'tasks_complete'],
        configuration: {
          'api_endpoint': '/tasks',
          'priority_levels': ['low', 'medium', 'high'],
        },
      ),
    ];
  }

  /// Select a profile
  void selectProfile(MCPProfile profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  /// Refresh profiles from the server
  Future<void> refreshProfiles() async {
    await _loadProfiles();
  }

  /// Update profile configuration
  Future<bool> updateProfile(MCPProfile profile) async {
    try {
      final index = _profiles.indexWhere((p) => p.id == profile.id);
      if (index != -1) {
        _profiles[index] = profile;
        if (_selectedProfile?.id == profile.id) {
          _selectedProfile = profile;
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  /// Toggle profile active status
  Future<void> toggleProfileStatus(String profileId) async {
    final profile = _profiles.firstWhere((p) => p.id == profileId);
    final updatedProfile = profile.copyWith(isActive: !profile.isActive);
    await updateProfile(updatedProfile);
  }
}
