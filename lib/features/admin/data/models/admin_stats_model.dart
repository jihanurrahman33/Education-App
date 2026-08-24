import '../../domain/entities/admin_stats_entity.dart';

class AdminStatsModel extends AdminStatsEntity {
  const AdminStatsModel({
    super.totalUsers = 0,
    required super.totalStudents,
    required super.totalTeachers,
    super.approvedTeachers = 0,
    required super.pendingTeachers,
    super.totalCourses = 0,
    super.approvedCourses = 0,
    required super.pendingCourses,
    super.rejectedCourses = 0,
    super.totalLessons = 0,
    super.totalEnrollments = 0,
    required super.certificatesIssued,
    super.quizSubmissions = 0,
    super.avgQuizScore = 0.0,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    final usersMap = json['users'] is Map<String, dynamic> ? json['users'] as Map<String, dynamic> : <String, dynamic>{};
    final coursesMap = json['courses'] is Map<String, dynamic> ? json['courses'] as Map<String, dynamic> : <String, dynamic>{};

    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      if (val is double) return val.toInt();
      return 0;
    }

    double parseDouble(dynamic val) {
      if (val is double) return val;
      if (val is int) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    return AdminStatsModel(
      totalUsers: parseInt(usersMap['total'] ?? json['total_users']),
      totalStudents: parseInt(usersMap['students'] ?? json['total_students']),
      totalTeachers: parseInt(usersMap['teachers'] ?? json['total_teachers']),
      approvedTeachers: parseInt(usersMap['approved_teachers'] ?? json['approved_teachers']),
      pendingTeachers: parseInt(usersMap['pending_teachers'] ?? json['pending_teachers']),
      totalCourses: parseInt(coursesMap['total'] ?? json['total_courses']),
      approvedCourses: parseInt(coursesMap['approved'] ?? json['active_courses'] ?? json['approved_courses']),
      pendingCourses: parseInt(coursesMap['pending'] ?? json['pending_courses']),
      rejectedCourses: parseInt(coursesMap['rejected'] ?? json['rejected_courses']),
      totalLessons: parseInt(json['lessons'] ?? json['total_lessons']),
      totalEnrollments: parseInt(json['enrollments'] ?? json['total_enrollments']),
      certificatesIssued: parseInt(json['certificates'] ?? json['certificates_issued']),
      quizSubmissions: parseInt(json['quiz_submissions']),
      avgQuizScore: parseDouble(json['avg_quiz_score']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': {
        'total': totalUsers,
        'students': totalStudents,
        'teachers': totalTeachers,
        'approved_teachers': approvedTeachers,
        'pending_teachers': pendingTeachers,
      },
      'courses': {
        'total': totalCourses,
        'approved': approvedCourses,
        'pending': pendingCourses,
        'rejected': rejectedCourses,
      },
      'lessons': totalLessons,
      'enrollments': totalEnrollments,
      'certificates': certificatesIssued,
      'quiz_submissions': quizSubmissions,
      'avg_quiz_score': avgQuizScore,
    };
  }
}
