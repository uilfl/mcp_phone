import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_session.dart';
import 'dart:convert';

/// Handles user authentication and session management
class AuthService extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  UserSession? _currentSession;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  UserSession? get currentSession => _currentSession;

  AuthService() {
    _loadSession();
  }

  /// Load session from secure storage
  Future<void> _loadSession() async {
    try {
      final sessionJson = await _secureStorage.read(key: 'user_session');
      if (sessionJson != null) {
        final session = UserSession.fromJson(jsonDecode(sessionJson));
        if (session.isValid) {
          _currentSession = session;
          _isAuthenticated = true;
          notifyListeners();
        } else {
          await clearSession();
        }
      }
    } catch (e) {
      debugPrint('Error loading session: $e');
    }
  }

  /// Authenticate user with credentials
  Future<bool> login(String username, String password) async {
    try {
      // TODO: Implement actual authentication with MCP Gateway
      // For now, create a mock session
      final session = UserSession(
        userId: username,
        accessToken: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      await _saveSession(session);
      _currentSession = session;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  /// Save session to secure storage
  Future<void> _saveSession(UserSession session) async {
    final sessionJson = jsonEncode(session.toJson());
    await _secureStorage.write(key: 'user_session', value: sessionJson);
  }

  /// Clear session and log out
  Future<void> logout() async {
    await clearSession();
  }

  /// Clear all session data
  Future<void> clearSession() async {
    await _secureStorage.delete(key: 'user_session');
    _currentSession = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Refresh the access token
  Future<bool> refreshToken() async {
    try {
      if (_currentSession?.refreshToken == null) {
        return false;
      }

      // TODO: Implement actual token refresh with MCP Gateway
      final newSession = UserSession(
        userId: _currentSession!.userId,
        accessToken: 'refreshed_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: _currentSession!.refreshToken,
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        userInfo: _currentSession!.userInfo,
      );

      await _saveSession(newSession);
      _currentSession = newSession;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Token refresh error: $e');
      return false;
    }
  }
}
