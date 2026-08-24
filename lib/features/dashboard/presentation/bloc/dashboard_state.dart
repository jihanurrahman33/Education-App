import 'package:equatable/equatable.dart';
import '../../domain/entities/student_dashboard_entity.dart';
import '../../domain/entities/teacher_dashboard_entity.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final StudentDashboardEntity? studentData;
  final TeacherDashboardEntity? teacherData;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.studentData,
    this.teacherData,
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    StudentDashboardEntity? studentData,
    TeacherDashboardEntity? teacherData,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      studentData: studentData ?? this.studentData,
      teacherData: teacherData ?? this.teacherData,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, studentData, teacherData, errorMessage];
}
