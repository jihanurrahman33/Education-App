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
  static const String chapters = '/api/courses/chapters/';
  static const String lessons = '/api/courses/lessons/';

  // Progress & Enrollment endpoints
  static const String enroll = '/api/progress/enroll/';
  static const String myEnrollments = '/api/progress/enrollments/';
  static const String progress = '/api/progress/my-progress/';
  static const String progressSummary = '/api/progress/my-progress/';
  static const String completeLesson = '/api/progress/complete/';
  static const String certificates = '/api/progress/certificates/';
  static const String generateCertificate = '/api/progress/certificates/generate/';

  // Quiz endpoints
  static const String quizzes = '/api/quizzes/quizzes/';
  static const String submitQuiz = '/api/quizzes/submit/';

  // Admin endpoints
  static const String adminPendingTeachers = '/api/admin-panel/teachers/pending/';
  static const String adminPendingCourses = '/api/admin-panel/courses/pending/';
  static const String adminStats = '/api/admin-panel/dashboard/';
}
