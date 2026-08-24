import 'package:equatable/equatable.dart';

class AdminTopCourseEntity extends Equatable {
  final int id;
  final String title;
  final String teacher;
  final String status;
  final int enrollments;

  const AdminTopCourseEntity({
    required this.id,
    required this.title,
    required this.teacher,
    required this.status,
    required this.enrollments,
  });

  bool get isApproved => status == 'approved';

  @override
  List<Object?> get props => [id, title, teacher, status, enrollments];
}
