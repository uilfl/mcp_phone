import 'package:json_annotation/json_annotation.dart';

part 'mcp_profile.g.dart';

/// Represents a curated MCP profile configuration
@JsonSerializable()
class MCPProfile {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String version;
  final List<String> capabilities;
  final Map<String, dynamic> configuration;
  final bool isActive;
  final DateTime? lastUpdated;

  MCPProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.version,
    required this.capabilities,
    required this.configuration,
    this.isActive = true,
    this.lastUpdated,
  });

  factory MCPProfile.fromJson(Map<String, dynamic> json) =>
      _$MCPProfileFromJson(json);

  Map<String, dynamic> toJson() => _$MCPProfileToJson(this);

  MCPProfile copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? version,
    List<String>? capabilities,
    Map<String, dynamic>? configuration,
    bool? isActive,
    DateTime? lastUpdated,
  }) {
    return MCPProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      version: version ?? this.version,
      capabilities: capabilities ?? this.capabilities,
      configuration: configuration ?? this.configuration,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
