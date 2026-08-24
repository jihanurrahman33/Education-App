import '../../domain/entities/admin_top_course_entity.dart';

class AdminTopCourseModel extends AdminTopCourseEntity {
  const AdminTopCourseModel({
    required super.id,
    required super.title,
    required super.teacher,
    required super.status,
    required super.enrollments,
  });

  factory AdminTopCourseModel.fromJson(Map<String, dynamic> json) {
    return AdminTopCourseModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      teacher: json['teacher'] as String? ?? '',
      status: json['status'] as String? ?? 'approved',
      enrollments: json['enrollments'] is int
          ? json['enrollments'] as int
          : int.tryParse(json['enrollments']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'teacher': teacher,
      'status': status,
      'enrollments': enrollments,
    };
  }
}
