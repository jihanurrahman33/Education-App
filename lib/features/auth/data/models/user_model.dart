import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.firstName,
    super.lastName,
    required super.role,
    super.isApprovedTeacher = false,
    super.token,
    super.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: UserRole.fromString(json['role'] as String?),
      isApprovedTeacher: json['is_approved_teacher'] as bool? ?? json['is_approved'] as bool? ?? false,
      token: json['access'] as String? ?? json['token'] as String?,
      refreshToken: json['refresh'] as String? ?? json['refresh_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'role': role.toApiValue(),
      'is_approved_teacher': isApprovedTeacher,
      'access': token,
      'refresh': refreshToken,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    UserRole? role,
    bool? isApprovedTeacher,
    String? token,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      isApprovedTeacher: isApprovedTeacher ?? this.isApprovedTeacher,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
