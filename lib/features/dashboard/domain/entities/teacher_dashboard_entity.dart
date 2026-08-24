import 'package:equatable/equatable.dart';

class TeacherDashboardEntity extends Equatable {
  final int authoredCoursesCount;
  final int totalStudentsEnrolled;
  final int activeQuizzesCount;

  const TeacherDashboardEntity({
    this.authoredCoursesCount = 0,
    this.totalStudentsEnrolled = 0,
    this.activeQuizzesCount = 0,
  });

  @override
  List<Object?> get props => [
        authoredCoursesCount,
        totalStudentsEnrolled,
        activeQuizzesCount,
      ];
}
