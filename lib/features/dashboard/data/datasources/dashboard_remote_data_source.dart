import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../models/student_dashboard_model.dart';
import '../models/teacher_dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<StudentDashboardModel> getStudentDashboard();
  Future<TeacherDashboardModel> getTeacherDashboard();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  const DashboardRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<StudentDashboardModel> getStudentDashboard() async {
    try {
      final results = await Future.wait([
        apiClient.get(ApiEndpoints.myProgress),
        apiClient.get(ApiEndpoints.certificates),
        apiClient.get(ApiEndpoints.completedLessons),
        apiClient.get(ApiEndpoints.enrollments),
      ]);

      final myProgressRes = results[0];
      final certificatesRes = results[1];
      final completedLessonsRes = results[2];
      final enrollmentsRes = results[3];

      // Parse myProgress
      final progressList = <Map<String, dynamic>>[];
      if (myProgressRes is List) {
        progressList.addAll(myProgressRes.whereType<Map<String, dynamic>>());
      } else if (myProgressRes is Map<String, dynamic> && myProgressRes['results'] is List) {
        progressList.addAll((myProgressRes['results'] as List).whereType<Map<String, dynamic>>());
      }

      // Parse enrollments
      final enrollmentsList = <Map<String, dynamic>>[];
      if (enrollmentsRes is List) {
        enrollmentsList.addAll(enrollmentsRes.whereType<Map<String, dynamic>>());
      } else if (enrollmentsRes is Map<String, dynamic> && enrollmentsRes['results'] is List) {
        enrollmentsList.addAll((enrollmentsRes['results'] as List).whereType<Map<String, dynamic>>());
      }

      // Parse certificates
      int certificatesCount = 0;
      if (certificatesRes is List) {
        certificatesCount = certificatesRes.length;
      } else if (certificatesRes is Map<String, dynamic>) {
        if (certificatesRes['count'] is int) {
          certificatesCount = certificatesRes['count'] as int;
        } else if (certificatesRes['results'] is List) {
          certificatesCount = (certificatesRes['results'] as List).length;
        }
      }

      // Parse completed lessons
      int completedLessonsCount = 0;
      if (completedLessonsRes is List) {
        completedLessonsCount = completedLessonsRes.length;
      } else if (completedLessonsRes is Map<String, dynamic>) {
        if (completedLessonsRes['count'] is int) {
          completedLessonsCount = completedLessonsRes['count'] as int;
        } else if (completedLessonsRes['results'] is List) {
          completedLessonsCount = (completedLessonsRes['results'] as List).length;
        }
      }

      // Enrolled courses count
      int enrolledCoursesCount = progressList.length;
      if (enrolledCoursesCount == 0 && enrollmentsList.isNotEmpty) {
        enrolledCoursesCount = enrollmentsList.length;
      }

      int progressCompletedLessons = 0;
      int completedCoursesCount = 0;
      String lastCourseTitle = 'Explore New Courses';
      String lastLessonSubtitle = 'Start your learning journey today';
      double progressRatio = 0.0;
      int? lastCourseId;

      Map<String, dynamic>? activeCourse;

      for (final p in progressList) {
        final compLessons = p['completed_lessons'] is int
            ? p['completed_lessons'] as int
            : int.tryParse(p['completed_lessons']?.toString() ?? '0') ?? 0;
        final totalLessons = p['total_lessons'] is int
            ? p['total_lessons'] as int
            : int.tryParse(p['total_lessons']?.toString() ?? '0') ?? 0;
        final rawPercent = p['progress_percent'] ?? p['percentage'] ?? 0;
        final percent = double.tryParse(rawPercent.toString()) ?? 0.0;

        progressCompletedLessons += compLessons;
        if (percent >= 100.0 || (totalLessons > 0 && compLessons >= totalLessons)) {
          completedCoursesCount++;
        }

        if (activeCourse == null) {
          activeCourse = p;
        } else {
          final activePercent = double.tryParse((activeCourse['progress_percent'] ?? activeCourse['percentage'] ?? 0).toString()) ?? 0.0;
          if (percent > 0 && percent < 100.0 && (activePercent == 0 || activePercent >= 100.0)) {
            activeCourse = p;
          }
        }
      }

      if (progressCompletedLessons > completedLessonsCount) {
        completedLessonsCount = progressCompletedLessons;
      }

      if (activeCourse != null) {
        lastCourseTitle = (activeCourse['course_title'] ?? activeCourse['title'] ?? 'Current Course') as String;
        final comp = activeCourse['completed_lessons'] is int
            ? activeCourse['completed_lessons'] as int
            : int.tryParse(activeCourse['completed_lessons']?.toString() ?? '0') ?? 0;
        final tot = activeCourse['total_lessons'] is int
            ? activeCourse['total_lessons'] as int
            : int.tryParse(activeCourse['total_lessons']?.toString() ?? '0') ?? 0;
        final rawPct = activeCourse['progress_percent'] ?? activeCourse['percentage'] ?? 0;
        final pct = double.tryParse(rawPct.toString()) ?? 0.0;

        lastLessonSubtitle = tot > 0
            ? '$comp of $tot lessons completed (${pct.toInt()}%)'
            : '${pct.toInt()}% completed';
        progressRatio = (pct / 100.0).clamp(0.0, 1.0);
        lastCourseId = activeCourse['course_id'] is int
            ? activeCourse['course_id'] as int
            : int.tryParse(activeCourse['course']?.toString() ?? activeCourse['id']?.toString() ?? '0');
      } else if (enrollmentsList.isNotEmpty) {
        final first = enrollmentsList.first;
        lastCourseTitle = (first['course_title'] ?? first['title'] ?? 'Enrolled Course') as String;
        lastLessonSubtitle = 'Ready to start learning';
        progressRatio = 0.0;
        lastCourseId = first['course'] is int
            ? first['course'] as int
            : int.tryParse(first['course']?.toString() ?? first['id']?.toString() ?? '0');
      }

      return StudentDashboardModel(
        enrolledCoursesCount: enrolledCoursesCount,
        completedLessonsCount: completedLessonsCount,
        certificatesEarnedCount: certificatesCount,
        completedCoursesCount: completedCoursesCount,
        lastCourseTitle: lastCourseTitle,
        lastLessonSubtitle: lastLessonSubtitle,
        progressRatio: progressRatio,
        lastCourseId: lastCourseId,
      );
    } catch (_) {
      return const StudentDashboardModel();
    }
  }

  @override
  Future<TeacherDashboardModel> getTeacherDashboard() async {
    try {
      final results = await Future.wait([
        apiClient.get(ApiEndpoints.teacherMyCourses),
        apiClient.get(ApiEndpoints.quizzes),
      ]);

      final coursesRes = results[0];
      final quizzesRes = results[1];

      final courseList = <Map<String, dynamic>>[];
      if (coursesRes is List) {
        courseList.addAll(coursesRes.whereType<Map<String, dynamic>>());
      } else if (coursesRes is Map<String, dynamic> && coursesRes['results'] is List) {
        courseList.addAll((coursesRes['results'] as List).whereType<Map<String, dynamic>>());
      }

      int totalStudents = 0;
      for (final c in courseList) {
        final enrolls = c['enrollments'] is int
            ? c['enrollments'] as int
            : int.tryParse(c['enrollments']?.toString() ?? '0') ?? 0;
        totalStudents += enrolls;
      }

      int quizzesCount = 0;
      if (quizzesRes is List) {
        quizzesCount = quizzesRes.length;
      } else if (quizzesRes is Map<String, dynamic>) {
        if (quizzesRes['count'] is int) {
          quizzesCount = quizzesRes['count'] as int;
        } else if (quizzesRes['results'] is List) {
          quizzesCount = (quizzesRes['results'] as List).length;
        }
      }

      return TeacherDashboardModel(
        authoredCoursesCount: courseList.length,
        totalStudentsEnrolled: totalStudents,
        activeQuizzesCount: quizzesCount,
      );
    } catch (_) {
      return const TeacherDashboardModel();
    }
  }
}
