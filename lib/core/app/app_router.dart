import 'package:go_router/go_router.dart';

// Public & Auth Screens
import '../../features/auth/presentation/screens/edit_profile_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';

// Dashboard & Splash
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/splash_screen.dart';
import '../../features/dashboard/presentation/screens/teacher_pending_screen.dart';

// Courses & Learning Screens
import '../../features/courses/presentation/screens/course_detail_screen.dart';
import '../../features/courses/presentation/screens/course_list_screen.dart';
import '../../features/courses/presentation/screens/lesson_learning_screen.dart';
import '../../features/courses/presentation/screens/my_enrolled_courses_screen.dart';
import '../../features/courses/presentation/screens/teacher_course_builder_screen.dart';
import '../../features/courses/presentation/screens/teacher_curriculum_manager_screen.dart';
import '../../features/courses/presentation/screens/teacher_lesson_create_screen.dart';

// Quizzes Screens
import '../../features/quizzes/presentation/screens/my_quiz_results_screen.dart';
import '../../features/quizzes/presentation/screens/quiz_list_screen.dart';
import '../../features/quizzes/presentation/screens/quiz_result_screen.dart';
import '../../features/quizzes/presentation/screens/take_quiz_screen.dart';
import '../../features/quizzes/presentation/screens/teacher_quiz_manager_screen.dart';
import '../../features/quizzes/presentation/screens/teacher_quiz_results_screen.dart';

// Progress & Certificates
import '../../features/certificates/presentation/screens/certificate_viewer_screen.dart';
import '../../features/certificates/presentation/screens/my_certificates_screen.dart';
import '../../features/progress/presentation/screens/my_progress_screen.dart';

// Admin Screens
import '../../features/admin/presentation/screens/admin_analytics_screen.dart';
import '../../features/admin/presentation/screens/admin_course_review_screen.dart';
import '../../features/admin/presentation/screens/admin_pending_courses_screen.dart';
import '../../features/admin/presentation/screens/admin_pending_teachers_screen.dart';
import '../../features/admin/presentation/screens/admin_user_management_screen.dart';

// Notifications & Settings
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

// Error Screen
import '../widgets/error_screen.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => ErrorScreen(
      statusCode: 404,
      title: 'Page Not Found',
      message: 'The requested route "${state.uri.path}" does not exist.',
    ),
    routes: [
      // 1. Splash & Welcome
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // 2. Authentication & Profile
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'];
          return RegisterScreen(initialRole: role);
        },
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) => const EditProfileScreen(),
          ),
        ],
      ),

      // 3. Core Dashboard
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // 4. Student Course Discovery & Details
      GoRoute(
        path: '/courses',
        builder: (context, state) => const CourseListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
              return CourseDetailScreen(courseId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/my-courses',
        builder: (context, state) => const MyEnrolledCoursesScreen(),
      ),
      GoRoute(
        path: '/learning/:courseId/lesson/:lessonId',
        builder: (context, state) {
          final courseId = int.tryParse(state.pathParameters['courseId'] ?? '0') ?? 0;
          final lessonId = int.tryParse(state.pathParameters['lessonId'] ?? '0') ?? 0;
          return LessonLearningScreen(courseId: courseId, lessonId: lessonId);
        },
      ),

      // 5. Quizzes & Assessments
      GoRoute(
        path: '/quizzes',
        builder: (context, state) => const QuizListScreen(),
        routes: [
          GoRoute(
            path: 'my-results',
            builder: (context, state) => const MyQuizResultsScreen(),
          ),
          GoRoute(
            path: ':id/take',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
              return TakeQuizScreen(quizId: id);
            },
          ),
          GoRoute(
            path: ':id/result',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
              final score = int.tryParse(state.uri.queryParameters['score'] ?? '0') ?? 0;
              final total = int.tryParse(state.uri.queryParameters['total'] ?? '0') ?? 0;
              final percentage = int.tryParse(state.uri.queryParameters['percentage'] ?? '0') ?? 0;

              return QuizResultScreen(
                quizId: id,
                score: score,
                total: total,
                percentage: percentage,
              );
            },
          ),
        ],
      ),

      // 6. Progress & Certificates
      GoRoute(
        path: '/progress',
        builder: (context, state) => const MyProgressScreen(),
      ),
      GoRoute(
        path: '/certificates',
        builder: (context, state) => const MyCertificatesScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
              return CertificateViewerScreen(certificateId: id);
            },
          ),
        ],
      ),

      // 7. Teacher Portal
      GoRoute(
        path: '/teacher/pending',
        builder: (context, state) => const TeacherPendingScreen(),
      ),
      GoRoute(
        path: '/teacher/courses/create',
        builder: (context, state) => const TeacherCourseBuilderScreen(),
      ),
      GoRoute(
        path: '/teacher/courses/:id/edit',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0');
          return TeacherCourseBuilderScreen(courseId: id);
        },
      ),
      GoRoute(
        path: '/teacher/courses/:courseId/curriculum',
        builder: (context, state) {
          final courseId = int.tryParse(state.pathParameters['courseId'] ?? '0') ?? 0;
          return TeacherCurriculumManagerScreen(courseId: courseId);
        },
      ),
      GoRoute(
        path: '/teacher/courses/:courseId/chapters/:chapterId/lessons/create',
        builder: (context, state) {
          final courseId = int.tryParse(state.pathParameters['courseId'] ?? '0') ?? 0;
          final chapterId = int.tryParse(state.pathParameters['chapterId'] ?? '0') ?? 0;
          return TeacherLessonCreateScreen(courseId: courseId, chapterId: chapterId);
        },
      ),
      GoRoute(
        path: '/teacher/quizzes',
        builder: (context, state) => const TeacherQuizManagerScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) => const TeacherQuizManagerScreen(),
          ),
          GoRoute(
            path: ':id/results',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
              return TeacherQuizResultsScreen(quizId: id);
            },
          ),
        ],
      ),

      // 8. Admin Portal
      GoRoute(
        path: '/admin/teachers/pending',
        builder: (context, state) => const AdminPendingTeachersScreen(),
      ),
      GoRoute(
        path: '/admin/courses/pending',
        builder: (context, state) => const AdminPendingCoursesScreen(),
      ),
      GoRoute(
        path: '/admin/courses/:id/review',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return AdminCourseReviewScreen(courseId: id);
        },
      ),
      GoRoute(
        path: '/admin/users',
        builder: (context, state) => const AdminUserManagementScreen(),
      ),
      GoRoute(
        path: '/admin/analytics',
        builder: (context, state) => const AdminAnalyticsScreen(),
      ),

      // 9. Shared Notifications & Settings
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
