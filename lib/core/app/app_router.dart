import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/courses/presentation/screens/course_detail_screen.dart';
import '../../features/courses/presentation/screens/course_list_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/splash_screen.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
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
    ],
  );
}
