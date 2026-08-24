class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = 'http://144.79.133.208:8000';

  // Auth endpoints
  static const String register = '/api/auth/register/';
  static const String login = '/api/auth/login/';
  static const String currentUser = '/api/auth/me/';
  static const String refreshToken = '/api/auth/token/refresh/';

  // Course endpoints
  static const String approvedCourses = '/api/courses/courses/approved/';
  static const String courses = '/api/courses/courses/';
  static const String myCourses = '/api/courses/courses/my-courses/';
  static const String teacherMyCourses = '/api/courses/courses/my-courses/';
  static const String chapters = '/api/courses/chapters/';
  static const String lessons = '/api/courses/lessons/';

  static String courseDetail(int id) => '/api/courses/courses/$id/';
  static String togglePublish(int id) => '/api/courses/courses/$id/toggle-publish/';
  static String chapterDetail(int id) => '/api/courses/chapters/$id/';
  static String lessonDetail(int id) => '/api/courses/lessons/$id/';

  // Progress & Enrollment endpoints
  static const String enroll = '/api/progress/enroll/';
  static const String enrollments = '/api/progress/enrollments/';
  static const String myEnrollments = '/api/progress/enrollments/';
  static const String progress = '/api/progress/my-progress/';
  static const String myProgress = '/api/progress/my-progress/';
  static const String progressSummary = '/api/progress/my-progress/';
  static const String completeLesson = '/api/progress/complete/';
  static const String completedLessons = '/api/progress/completed/';
  static const String certificates = '/api/progress/certificates/';

  static String courseProgress(int id) => '/api/progress/course/$id/';
  static String generateCertificate(int id) => '/api/progress/certificate/$id/';
  static String teacherCourseStudentsProgress(int id) => '/api/progress/teacher/course/$id/students/';

  // Quiz endpoints
  static const String quizzes = '/api/quizzes/quizzes/';
  static const String myQuizResults = '/api/quizzes/quizzes/my-results/';
  static const String questions = '/api/quizzes/questions/';

  static String quizDetail(int id) => '/api/quizzes/quizzes/$id/';
  static String quizTake(int id) => '/api/quizzes/quizzes/$id/take/';
  static String quizSubmit(int id) => '/api/quizzes/quizzes/$id/submit/';
  static String quizResults(int id) => '/api/quizzes/quizzes/$id/results/';
  static String questionDetail(int id) => '/api/quizzes/questions/$id/';

  // Admin endpoints
  static const String adminPendingTeachers = '/api/admin-panel/teachers/pending/';
  static const String adminPendingCourses = '/api/admin-panel/courses/pending/';
  static const String adminStats = '/api/admin-panel/dashboard/';
  static const String adminTopCourses = '/api/admin-panel/top-courses/';
  static const String adminUsers = '/api/admin-panel/users/';

  static String adminUserDetail(int id) => '/api/admin-panel/users/$id/';
  static String adminApproveTeacher(int id) => '/api/admin-panel/teachers/$id/approve/';
  static String adminApproveCourse(int id) => '/api/admin-panel/courses/$id/approve/';
  static String adminRejectCourse(int id) => '/api/admin-panel/courses/$id/reject/';
}
