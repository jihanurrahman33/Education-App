import '../../domain/entities/token_refresh_entity.dart';

class TokenRefreshModel extends TokenRefreshEntity {
  const TokenRefreshModel({
    required super.refresh,
    required super.access,
  });

  factory TokenRefreshModel.fromJson(Map<String, dynamic> json, {String? defaultRefresh}) {
    return TokenRefreshModel(
      refresh: json['refresh'] as String? ?? defaultRefresh ?? '',
      access: json['access'] as String? ?? json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
      'access': access,
    };
  }
}
