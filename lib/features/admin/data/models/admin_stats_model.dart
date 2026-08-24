import '../../domain/entities/admin_stats_entity.dart';

class AdminStatsModel extends AdminStatsEntity {
  const AdminStatsModel({
    required super.totalStudents,
    required super.totalTeachers,
    required super.pendingTeachers,
    required super.pendingCourses,
    required super.activeCourses,
    required super.certificatesIssued,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalStudents: json['total_students'] as int? ?? 0,
      totalTeachers: json['total_teachers'] as int? ?? 0,
      pendingTeachers: json['pending_teachers'] as int? ?? 0,
      pendingCourses: json['pending_courses'] as int? ?? 0,
      activeCourses: json['active_courses'] as int? ?? 0,
      certificatesIssued: json['certificates_issued'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_students': totalStudents,
      'total_teachers': totalTeachers,
      'pending_teachers': pendingTeachers,
      'pending_courses': pendingCourses,
      'active_courses': activeCourses,
      'certificates_issued': certificatesIssued,
    };
  }
}
