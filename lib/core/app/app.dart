import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/admin/presentation/bloc/admin_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/certificates/presentation/bloc/certificate_bloc.dart';
import '../../features/courses/presentation/bloc/course_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/notifications/presentation/bloc/notification_bloc.dart';
import '../../features/progress/presentation/bloc/progress_bloc.dart';
import '../../features/quizzes/presentation/bloc/quiz_bloc.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import 'app_router.dart';
import 'injection_container.dart';

class EducationApp extends StatelessWidget {
  const EducationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
        BlocProvider<CourseBloc>(
          create: (_) => sl<CourseBloc>(),
        ),
        BlocProvider<QuizBloc>(
          create: (_) => sl<QuizBloc>(),
        ),
        BlocProvider<AdminBloc>(
          create: (_) => sl<AdminBloc>(),
        ),
        BlocProvider<ProgressBloc>(
          create: (_) => sl<ProgressBloc>(),
        ),
        BlocProvider<CertificateBloc>(
          create: (_) => sl<CertificateBloc>(),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => sl<DashboardBloc>(),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => sl<SettingsBloc>(),
        ),
        BlocProvider<NotificationBloc>(
          create: (_) => sl<NotificationBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
