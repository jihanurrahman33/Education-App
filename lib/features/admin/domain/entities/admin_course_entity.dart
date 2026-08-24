import 'package:equatable/equatable.dart';

class AdminCourseEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final int teacher;
  final String teacherName;
  final String status;
  final bool isPublished;
  final String createdAt;
  final String updatedAt;

  const AdminCourseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.teacher,
    required this.teacherName,
    required this.status,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        teacher,
        teacherName,
        status,
        isPublished,
        createdAt,
        updatedAt,
      ];
}
