import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    super.firstName,
    super.lastName,
    required super.role,
    super.phone,
    super.bio,
    super.avatar,
    super.isApprovedTeacher = false,
    super.approvedAt,
    super.isActive = true,
    super.dateJoined,
    super.createdAt,
    super.token,
    super.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: UserRole.fromString(json['role'] as String?),
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
      avatar: json['avatar'] as String?,
      isApprovedTeacher: json['is_approved_teacher'] as bool? ?? json['is_approved'] as bool? ?? false,
      approvedAt: json['approved_at'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      dateJoined: json['date_joined'] as String?,
      createdAt: json['created_at'] as String?,
      token: json['access'] as String? ?? json['token'] as String?,
      refreshToken: json['refresh'] as String? ?? json['refresh_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role.toApiValue(),
      'phone': phone,
      'bio': bio,
      'avatar': avatar,
      'is_approved_teacher': isApprovedTeacher,
      'approved_at': approvedAt,
      'is_active': isActive,
      'date_joined': dateJoined,
      'created_at': createdAt,
      'access': token,
      'refresh': refreshToken,
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    String? phone,
    String? bio,
    String? avatar,
    bool? isApprovedTeacher,
    String? approvedAt,
    bool? isActive,
    String? dateJoined,
    String? createdAt,
    String? token,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      isApprovedTeacher: isApprovedTeacher ?? this.isApprovedTeacher,
      approvedAt: approvedAt ?? this.approvedAt,
      isActive: isActive ?? this.isActive,
      dateJoined: dateJoined ?? this.dateJoined,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
