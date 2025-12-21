import 'package:json_annotation/json_annotation.dart';

part 'user_session.g.dart';

@JsonSerializable()
class UserSession {
  final String userId;
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final Map<String, dynamic>? userInfo;

  UserSession({
    required this.userId,
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
    this.userInfo,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSessionToJson(this);

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get isValid => !isExpired && accessToken.isNotEmpty;
}
