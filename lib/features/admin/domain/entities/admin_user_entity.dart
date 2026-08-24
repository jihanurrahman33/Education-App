import 'package:equatable/equatable.dart';

class AdminUserEntity extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String role;
  final String? phone;
  final bool isActive;
  final bool isApprovedTeacher;
  final String? approvedAt;
  final String? dateJoined;

  const AdminUserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    required this.role,
    this.phone,
    this.isActive = true,
    this.isApprovedTeacher = false,
    this.approvedAt,
    this.dateJoined,
  });

  String get fullName {
    if (firstName != null && firstName!.isNotEmpty) {
      if (lastName != null && lastName!.isNotEmpty) {
        return '$firstName $lastName'.trim();
      }
      return firstName!;
    }
    return username;
  }

  bool get isTeacher => role.toLowerCase() == 'teacher';
  bool get isStudent => role.toLowerCase() == 'student';
  bool get isAdmin => role.toLowerCase() == 'admin';

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        firstName,
        lastName,
        role,
        phone,
        isActive,
        isApprovedTeacher,
        approvedAt,
        dateJoined,
      ];
}
