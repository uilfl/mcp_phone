import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat_message.dart';
import '../models/mcp_profile.dart';
import 'auth_service.dart';

/// Handles communication with the MCP Gateway backend
class MCPGatewayService extends ChangeNotifier {
  static const String _baseUrl = 'http://localhost:3000/api'; // TODO: Configure based on environment
  
  final List<ChatMessage> _messages = [];
  bool _isProcessing = false;
  AuthService? _authService;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isProcessing => _isProcessing;

  void setAuthService(AuthService authService) {
    _authService = authService;
  }

  /// Send a message to the MCP Gateway
  Future<void> sendMessage(String content, MCPProfile profile) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessage.user(content);
    _messages.add(userMessage);
    notifyListeners();

    _isProcessing = true;
    notifyListeners();

    try {
      final response = await _makeRequest(
        'POST',
        '/chat',
        body: {
          'message': content,
          'profile_id': profile.id,
          'conversation_id': _getCurrentConversationId(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final assistantMessage = ChatMessage.assistant(
          data['response'] ?? 'No response received',
          metadata: data['metadata'],
        );
        _messages.add(assistantMessage);
      } else {
        _messages.add(ChatMessage.error('Failed to get response: ${response.statusCode}'));
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      _messages.add(ChatMessage.error('Error: ${e.toString()}'));
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Make an HTTP request to the MCP Gateway
  Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final requestHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };

    // Add authorization header if available
    if (_authService?.currentSession?.accessToken != null) {
      requestHeaders['Authorization'] = 'Bearer ${_authService!.currentSession!.accessToken}';
    }

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(url, headers: requestHeaders);
      case 'POST':
        return await http.post(
          url,
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return await http.put(
          url,
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return await http.delete(url, headers: requestHeaders);
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }
  }

  /// Get current conversation ID (generates a new one if not exists)
  String _getCurrentConversationId() {
    // TODO: Implement proper conversation management
    return 'conv_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Clear conversation history
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  /// Check gateway health
  Future<bool> checkHealth() async {
    try {
      final response = await _makeRequest('GET', '/health');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Health check failed: $e');
      return false;
    }
  }

  /// Get available capabilities for a profile
  Future<List<String>> getProfileCapabilities(String profileId) async {
    try {
      final response = await _makeRequest('GET', '/profiles/$profileId/capabilities');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['capabilities'] ?? []);
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching capabilities: $e');
      return [];
    }
  }
}
