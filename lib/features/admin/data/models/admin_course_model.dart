import '../../domain/entities/admin_course_entity.dart';

class AdminCourseModel extends AdminCourseEntity {
  const AdminCourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.teacher,
    required super.teacherName,
    required super.status,
    required super.isPublished,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AdminCourseModel.fromJson(Map<String, dynamic> json) {
    return AdminCourseModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      teacher: json['teacher'] is int
          ? json['teacher'] as int
          : int.tryParse(json['teacher']?.toString() ?? '0') ?? 0,
      teacherName: json['teacher_name'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      isPublished: json['is_published'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'teacher': teacher,
      'teacher_name': teacherName,
      'status': status,
      'is_published': isPublished,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
