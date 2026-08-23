import 'package:equatable/equatable.dart';

enum UserRole {
  student,
  teacher,
  admin;

  static UserRole fromString(String? role) {
    switch (role?.toLowerCase()) {
      case 'teacher':
        return UserRole.teacher;
      case 'admin':
        return UserRole.admin;
      case 'student':
      default:
        return UserRole.student;
    }
  }

  String toApiValue() {
    switch (this) {
      case UserRole.teacher:
        return 'teacher';
      case UserRole.admin:
        return 'admin';
      case UserRole.student:
        return 'student';
    }
  }
}

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;
  final UserRole role;
  final bool isApprovedTeacher;
  final String? token;
  final String? refreshToken;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    required this.role,
    this.isApprovedTeacher = false,
    this.token,
    this.refreshToken,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName'.trim();
    }
    return username;
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        firstName,
        lastName,
        role,
        isApprovedTeacher,
        token,
        refreshToken,
      ];
}
