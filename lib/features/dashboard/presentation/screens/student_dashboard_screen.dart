import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../courses/presentation/bloc/course_bloc.dart';
import '../../../courses/presentation/bloc/course_event.dart';
import '../../../courses/presentation/bloc/course_state.dart';
import '../../../courses/presentation/widgets/course_card_widget.dart';
import '../widgets/continue_learning_card_widget.dart';
import '../widgets/dashboard_stat_card_widget.dart';
import '../widgets/quick_action_chip_widget.dart';
import '../widgets/student_greeting_banner_widget.dart';

class StudentDashboardScreen extends StatefulWidget {
  final UserEntity user;

  const StudentDashboardScreen({super.key, required this.user});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(const FetchCoursesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reusable Student Greeting Banner
          StudentGreetingBannerWidget(
            studentName: widget.user.fullName,
            onNotificationTap: () => context.push('/notifications'),
          ),
          const SizedBox(height: 20),

          // Reusable Continue Learning Card
          ContinueLearningCardWidget(
            courseTitle: 'Full-Stack Modern App Architecture',
            lessonSubtitle: 'Chapter 3: State Management & BLoC Patterns • Lesson 4',
            progressRatio: 0.75,
            onResume: () => context.push('/learning/1/lesson/4'),
            onTakeQuiz: () => context.push('/quizzes'),
          ),
          const SizedBox(height: 20),

          // Reusable Quick Stats Row
          Row(
            children: [
              DashboardStatCardWidget(
                title: 'Enrolled',
                count: '4 Courses',
                icon: Icons.bookmark_added_rounded,
                color: AppColors.primary,
                onTap: () => context.push('/my-courses'),
              ),
              const SizedBox(width: 10),
              DashboardStatCardWidget(
                title: 'Completed',
                count: '18 Lessons',
                icon: Icons.check_circle_rounded,
                color: AppColors.secondary,
                onTap: () => context.push('/progress'),
              ),
              const SizedBox(width: 10),
              DashboardStatCardWidget(
                title: 'Certificates',
                count: '2 Earned',
                icon: Icons.workspace_premium_rounded,
                color: AppColors.accent,
                onTap: () => context.push('/certificates'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Reusable Quick Action Hub
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              QuickActionChipWidget(
                label: 'Explore Courses',
                icon: Icons.explore_rounded,
                color: AppColors.primary,
                onTap: () => context.push('/courses'),
              ),
              const SizedBox(width: 8),
              QuickActionChipWidget(
                label: 'My Quizzes',
                icon: Icons.quiz_rounded,
                color: AppColors.secondary,
                onTap: () => context.push('/quizzes'),
              ),
              const SizedBox(width: 8),
              QuickActionChipWidget(
                label: 'Certificates',
                icon: Icons.military_tech_rounded,
                color: AppColors.tertiary,
                onTap: () => context.push('/certificates'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Explore Courses Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Explore Courses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/courses'),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          BlocBuilder<CourseBloc, CourseState>(
            builder: (context, state) {
              if (state.status.isLoading && state.courses.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state.courses.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(32.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.school_outlined, size: 40, color: AppColors.outline),
                      SizedBox(height: 8),
                      Text(
                        'No courses available right now.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              final displayCourses = state.courses.take(3).toList();
              return Column(
                children: displayCourses.map((course) {
                  return CourseCardWidget(
                    course: course,
                    onTap: () => context.push('/courses/${course.id}'),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
