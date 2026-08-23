import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../auth/domain/entities/user_entity.dart';
import '../../courses/presentation/bloc/course_bloc.dart';
import '../../courses/presentation/bloc/course_event.dart';
import '../../courses/presentation/bloc/course_state.dart';
import '../../courses/presentation/widgets/course_card_widget.dart';

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
          // Greeting Card
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${widget.user.fullName}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ready to continue your courses today?',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.auto_stories_rounded,
                  size: 48,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Stats
          Row(
            children: [
              _buildStatCard('Enrolled', '0', Icons.bookmark_added_rounded, AppColors.primary),
              const SizedBox(width: 12),
              _buildStatCard('Completed', '0', Icons.check_circle_rounded, AppColors.secondary),
              const SizedBox(width: 12),
              _buildStatCard('Certificates', '0', Icons.workspace_premium_rounded, AppColors.accent),
            ],
          ),
          const SizedBox(height: 28),

          // Available Courses Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Explore Courses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/courses'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Courses List
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
                  child: const Text(
                    'No courses available right now.',
                    style: TextStyle(color: AppColors.textSecondary),
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

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              count,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
