class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = 'http://144.79.133.208:8000';

  // 1. Authentication endpoints
  static const String register = '/api/auth/register/';
  static const String login = '/api/auth/login/';
  static const String currentUser = '/api/auth/me/';
  static const String refreshToken = '/api/auth/refresh/';

  // 2. Course endpoints
  static const String courses = '/api/courses/courses/';
  static const String approvedCourses = '/api/courses/courses/approved/';
  static const String myEnrollments = '/api/courses/courses/approved/';
  static String courseDetail(int id) => '/api/courses/courses/$id/';
  static String togglePublish(int id) => '/api/courses/courses/$id/toggle-publish/';
  static const String chapters = '/api/courses/chapters/';
  static String chapterDetail(int id) => '/api/courses/chapters/$id/';
  static const String lessons = '/api/courses/lessons/';
  static String lessonDetail(int id) => '/api/courses/lessons/$id/';

  // 3. Quiz endpoints
  static const String quizzes = '/api/quizzes/quizzes/';
  static const String quizQuestions = '/api/quizzes/questions/';
  static String takeQuiz(int id) => '/api/quizzes/quizzes/$id/take/';
  static String submitQuiz(int id) => '/api/quizzes/quizzes/$id/submit/';
  static const String myQuizResults = '/api/quizzes/quizzes/my-results/';
  static String quizResults(int id) => '/api/quizzes/quizzes/$id/results/';

  // 4. Progress & Enrollment endpoints
  static const String enroll = '/api/progress/enroll/';
  static const String completeLesson = '/api/progress/complete/';
  static String courseProgress(int id) => '/api/progress/course/$id/';
  static const String myProgress = '/api/progress/my-progress/';
  static const String progressSummary = '/api/progress/my-progress/';
  static const String progress = '/api/progress/my-progress/';
  static String generateCertificate(int id) => '/api/progress/certificate/$id/';
  static const String certificates = '/api/progress/certificates/';

  // 5. Admin Panel endpoints
  static const String adminUsers = '/api/admin-panel/users/';
  static String adminUserDetail(int id) => '/api/admin-panel/users/$id/';
  static const String adminPendingTeachers = '/api/admin-panel/teachers/pending/';
  static String adminApproveTeacher(int id) => '/api/admin-panel/teachers/$id/approve/';
  static const String adminPendingCourses = '/api/admin-panel/courses/pending/';
  static String adminApproveCourse(int id) => '/api/admin-panel/courses/$id/approve/';
  static String adminRejectCourse(int id) => '/api/admin-panel/courses/$id/reject/';
  static const String adminStats = '/api/admin-panel/dashboard/';
  static const String adminTopCourses = '/api/admin-panel/top-courses/';
}
