import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../courses/presentation/bloc/course_bloc.dart';
import '../../../courses/presentation/bloc/course_event.dart';
import '../../../courses/presentation/bloc/course_state.dart';
import '../../../courses/presentation/widgets/course_card_widget.dart';
import '../../domain/entities/student_dashboard_entity.dart';
import '../../domain/usecases/get_student_dashboard_use_case.dart';
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
  final GetStudentDashboardUseCase _getStudentDashboardUseCase = GetIt.I<GetStudentDashboardUseCase>();

  StudentDashboardEntity _dashboardData = const StudentDashboardEntity();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    context.read<CourseBloc>().add(const FetchCoursesRequested());
  }

  Future<void> _loadDashboardData() async {
    final result = await _getStudentDashboardUseCase(const NoParams());
    if (!mounted) return;

    result.fold(
      (_) => null,
      (data) => setState(() => _dashboardData = data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadDashboardData();
        if (!context.mounted) return;
        context.read<CourseBloc>().add(const FetchCoursesRequested());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Greeting Banner
            StudentGreetingBannerWidget(
              studentName: widget.user.fullName,
              onNotificationTap: () => context.push('/notifications'),
            ),
            const SizedBox(height: 20),

            // Continue Learning Card
            ContinueLearningCardWidget(
              courseTitle: _dashboardData.lastCourseTitle,
              lessonSubtitle: _dashboardData.lastLessonSubtitle,
              progressRatio: _dashboardData.progressRatio,
              onResume: () => context.push('/courses'),
              onTakeQuiz: () => context.push('/quizzes'),
            ),
            const SizedBox(height: 20),

            // Quick Stats Row
            Row(
              children: [
                DashboardStatCardWidget(
                  title: 'Enrolled',
                  count: '${_dashboardData.enrolledCoursesCount} Courses',
                  icon: Icons.bookmark_added_rounded,
                  color: AppColors.primary,
                  onTap: () => context.push('/my-courses'),
                ),
                const SizedBox(width: 10),
                DashboardStatCardWidget(
                  title: 'Completed',
                  count: '${_dashboardData.completedLessonsCount} Lessons',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.secondary,
                  onTap: () => context.push('/progress'),
                ),
                const SizedBox(width: 10),
                DashboardStatCardWidget(
                  title: 'Certificates',
                  count: '${_dashboardData.certificatesEarnedCount} Earned',
                  icon: Icons.workspace_premium_rounded,
                  color: AppColors.accent,
                  onTap: () => context.push('/certificates'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Action Hub
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
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
                    color: AppColors.textPrimary,
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
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  );
                }

                if (state.courses.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.school_outlined, size: 40, color: AppColors.textMuted),
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
      ),
    );
  }
}
