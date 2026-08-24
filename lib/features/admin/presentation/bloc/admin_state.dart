import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_dashboard_entity.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../../domain/entities/pending_course_entity.dart';
import '../../domain/entities/pending_teacher_entity.dart';
import '../../domain/entities/top_course_entity.dart';

enum AdminStatus { initial, loading, success, failure }

class AdminState extends Equatable {
  final AdminStatus status;
  final AdminDashboardEntity? dashboardStats;
  final List<TopCourseEntity> topCourses;
  final List<PendingTeacherEntity> pendingTeachers;
  final List<PendingCourseEntity> pendingCourses;
  final List<AdminUserEntity> users;
  final String? errorMessage;
  final String? successMessage;

  const AdminState({
    this.status = AdminStatus.initial,
    this.dashboardStats,
    this.topCourses = const [],
    this.pendingTeachers = const [],
    this.pendingCourses = const [],
    this.users = const [],
    this.errorMessage,
    this.successMessage,
  });

  AdminState copyWith({
    AdminStatus? status,
    AdminDashboardEntity? dashboardStats,
    List<TopCourseEntity>? topCourses,
    List<PendingTeacherEntity>? pendingTeachers,
    List<PendingCourseEntity>? pendingCourses,
    List<AdminUserEntity>? users,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return AdminState(
      status: status ?? this.status,
      dashboardStats: dashboardStats ?? this.dashboardStats,
      topCourses: topCourses ?? this.topCourses,
      pendingTeachers: pendingTeachers ?? this.pendingTeachers,
      pendingCourses: pendingCourses ?? this.pendingCourses,
      users: users ?? this.users,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        dashboardStats,
        topCourses,
        pendingTeachers,
        pendingCourses,
        users,
        errorMessage,
        successMessage,
      ];
}
