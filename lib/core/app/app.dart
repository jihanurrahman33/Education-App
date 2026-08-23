import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/courses/presentation/bloc/course_bloc.dart';
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
