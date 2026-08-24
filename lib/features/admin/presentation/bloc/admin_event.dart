import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdminDashboardEvent extends AdminEvent {
  const LoadAdminDashboardEvent();
}

class LoadPendingTeachersEvent extends AdminEvent {
  const LoadPendingTeachersEvent();
}

class ApproveTeacherEvent extends AdminEvent {
  final int teacherId;

  const ApproveTeacherEvent(this.teacherId);

  @override
  List<Object?> get props => [teacherId];
}

class LoadPendingCoursesEvent extends AdminEvent {
  const LoadPendingCoursesEvent();
}

class ApproveCourseEvent extends AdminEvent {
  final int courseId;

  const ApproveCourseEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class RejectCourseEvent extends AdminEvent {
  final int courseId;

  const RejectCourseEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class LoadAdminUsersEvent extends AdminEvent {
  final int? page;

  const LoadAdminUsersEvent({this.page});

  @override
  List<Object?> get props => [page];
}

class CreateAdminUserEvent extends AdminEvent {
  final String username;
  final String email;
  final String password;
  final String role;
  final String firstName;
  final String lastName;
  final String phone;
  final bool isActive;
  final bool isApprovedTeacher;

  const CreateAdminUserEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.isActive = true,
    this.isApprovedTeacher = false,
  });

  @override
  List<Object?> get props => [
        username,
        email,
        password,
        role,
        firstName,
        lastName,
        phone,
        isActive,
        isApprovedTeacher,
      ];
}

class UpdateAdminUserEvent extends AdminEvent {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String phone;
  final bool isActive;
  final bool isApprovedTeacher;

  const UpdateAdminUserEvent({
    required this.id,
    required this.username,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.role = 'student',
    this.phone = '',
    this.isActive = true,
    this.isApprovedTeacher = false,
  });

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
      ];
}

class ToggleUserStatusEvent extends AdminEvent {
  final int userId;
  final bool isActive;

  const ToggleUserStatusEvent({required this.userId, required this.isActive});

  @override
  List<Object?> get props => [userId, isActive];
}

class DeleteAdminUserEvent extends AdminEvent {
  final int userId;

  const DeleteAdminUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
