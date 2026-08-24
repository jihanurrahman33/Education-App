import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/enrolled_course_card_widget.dart';

class MyEnrolledCoursesScreen extends StatefulWidget {
  const MyEnrolledCoursesScreen({super.key});

  @override
  State<MyEnrolledCoursesScreen> createState() => _MyEnrolledCoursesScreenState();
}

class _MyEnrolledCoursesScreenState extends State<MyEnrolledCoursesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(const FetchCoursesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'My Enrolled Courses',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state.status.isLoading && state.courses.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) => const LoadingSkeletonCard(height: 140),
            );
          }

          final enrolledCourses = state.courses.where((c) => c.isEnrolled).toList();
          final displayCourses = enrolledCourses.isNotEmpty ? enrolledCourses : state.courses.take(2).toList();

          if (displayCourses.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.bookmark_border_rounded,
              title: 'No Active Enrollments',
              message: 'You have not enrolled in any courses yet. Explore our catalog and begin your journey!',
              actionText: 'Browse Courses',
              onAction: () => context.push('/courses'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: displayCourses.length,
            itemBuilder: (context, index) {
              final course = displayCourses[index];
              final progress = (index == 0) ? 0.75 : 0.40;

              return EnrolledCourseCardWidget(
                course: course,
                progress: progress,
                onTap: () => context.push('/courses/${course.id}'),
                onResume: () => context.push('/learning/${course.id}/lesson/1'),
              );
            },
          );
        },
      ),
    );
  }
}
