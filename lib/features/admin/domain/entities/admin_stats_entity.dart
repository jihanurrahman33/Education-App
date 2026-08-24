import 'package:equatable/equatable.dart';

class AdminStatsEntity extends Equatable {
  final int totalUsers;
  final int totalStudents;
  final int totalTeachers;
  final int approvedTeachers;
  final int pendingTeachers;
  final int totalCourses;
  final int approvedCourses;
  final int pendingCourses;
  final int rejectedCourses;
  final int totalLessons;
  final int totalEnrollments;
  final int certificatesIssued;
  final int quizSubmissions;
  final double avgQuizScore;

  const AdminStatsEntity({
    this.totalUsers = 0,
    required this.totalStudents,
    required this.totalTeachers,
    this.approvedTeachers = 0,
    required this.pendingTeachers,
    this.totalCourses = 0,
    this.approvedCourses = 0,
    required this.pendingCourses,
    this.rejectedCourses = 0,
    this.totalLessons = 0,
    this.totalEnrollments = 0,
    required this.certificatesIssued,
    this.quizSubmissions = 0,
    this.avgQuizScore = 0.0,
  });

  // Backward-compatible alias
  int get activeCourses => approvedCourses;

  @override
  List<Object?> get props => [
        totalUsers,
        totalStudents,
        totalTeachers,
        approvedTeachers,
        pendingTeachers,
        totalCourses,
        approvedCourses,
        pendingCourses,
        rejectedCourses,
        totalLessons,
        totalEnrollments,
        certificatesIssued,
        quizSubmissions,
        avgQuizScore,
      ];
}
