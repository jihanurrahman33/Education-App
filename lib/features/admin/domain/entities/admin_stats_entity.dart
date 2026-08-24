import 'package:equatable/equatable.dart';

class AdminStatsEntity extends Equatable {
  final int totalStudents;
  final int totalTeachers;
  final int pendingTeachers;
  final int pendingCourses;
  final int activeCourses;
  final int certificatesIssued;

  const AdminStatsEntity({
    required this.totalStudents,
    required this.totalTeachers,
    required this.pendingTeachers,
    required this.pendingCourses,
    required this.activeCourses,
    required this.certificatesIssued,
  });

  @override
  List<Object?> get props => [
        totalStudents,
        totalTeachers,
        pendingTeachers,
        pendingCourses,
        activeCourses,
        certificatesIssued,
      ];
}
