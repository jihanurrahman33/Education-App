class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = 'https://education-app-api.example.com';

  // Auth endpoints
  static const String register = '/api/auth/register/';
  static const String login = '/api/auth/login/';
  static const String currentUser = '/api/auth/me/';
  static const String refreshToken = '/api/auth/refresh/';

  // Course endpoints
  static const String courses = '/api/courses/courses/';
  static const String categories = '/api/courses/categories/';
  static const String chapters = '/api/courses/chapters/';
  static const String lessons = '/api/courses/lessons/';
  static const String enroll = '/api/courses/enroll/';
  static const String myEnrollments = '/api/courses/my-enrollments/';

  // Quiz endpoints
  static const String quizzes = '/api/quizzes/quizzes/';
  static const String questions = '/api/quizzes/questions/';
  static const String submitQuiz = '/api/quizzes/submissions/';

  // Progress endpoints
  static const String progress = '/api/progress/progress/';
  static const String completeLesson = '/api/progress/lessons/complete/';
  static const String progressSummary = '/api/progress/summary/';

  // Certificate endpoints
  static const String certificates = '/api/certificates/certificates/';
  static const String generateCertificate = '/api/certificates/generate/';

  // Admin endpoints
  static const String adminUsers = '/api/admin/users/';
  static const String adminPendingTeachers = '/api/admin/teachers/pending/';
  static const String adminApproveTeacher = '/api/admin/teachers/approve/';
  static const String adminPendingCourses = '/api/admin/courses/pending/';
  static const String adminApproveCourse = '/api/admin/courses/approve/';
  static const String adminStats = '/api/admin/stats/';
}
