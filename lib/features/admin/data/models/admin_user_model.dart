import '../../domain/entities/admin_user_entity.dart';

class AdminUserModel extends AdminUserEntity {
  const AdminUserModel({
    required super.id,
    required super.username,
    required super.email,
    super.firstName,
    super.lastName,
    required super.role,
    super.phone,
    super.isActive = true,
    super.isApprovedTeacher = false,
    super.approvedAt,
    super.dateJoined,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: json['role'] as String? ?? 'student',
      phone: json['phone'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isApprovedTeacher: json['is_approved_teacher'] as bool? ?? false,
      approvedAt: json['approved_at'] as String?,
      dateJoined: json['date_joined'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'phone': phone,
      'is_active': isActive,
      'is_approved_teacher': isApprovedTeacher,
      'approved_at': approvedAt,
      'date_joined': dateJoined,
    };
  }
}
