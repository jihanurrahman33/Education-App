import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../certificates/presentation/bloc/certificate_bloc.dart';
import '../../../certificates/presentation/bloc/certificate_event.dart';
import '../../../courses/presentation/bloc/course_bloc.dart';
import '../../../courses/presentation/bloc/course_event.dart';
import '../../../courses/presentation/bloc/course_state.dart';
import '../../../courses/presentation/widgets/course_card_widget.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../../progress/presentation/bloc/progress_event.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
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
    _loadDashboardData();
  }

  void _loadDashboardData() {
    context.read<DashboardBloc>().add(const LoadStudentDashboardEvent());
    context.read<CourseBloc>().add(const FetchApprovedCoursesRequested());
    context.read<ProgressBloc>().add(const LoadMyProgressEvent());
    context.read<CertificateBloc>().add(const LoadCertificatesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, dashState) {
        final dashboardData = dashState.studentData;
        final certState = context.watch<CertificateBloc>().state;
        final progressState = context.watch<ProgressBloc>().state;

        final enrolledCount = (dashboardData?.enrolledCoursesCount ?? 0) > 0
            ? dashboardData!.enrolledCoursesCount
            : progressState.myProgress.length;

        final completedLessonsCount = (dashboardData?.completedLessonsCount ?? 0) > 0
            ? dashboardData!.completedLessonsCount
            : progressState.myProgress.fold<int>(
                0, (sum, c) => sum + c.completedLessons);

        final certsEarnedCount = (dashboardData?.certificatesEarnedCount ?? 0) > 0
            ? dashboardData!.certificatesEarnedCount
            : (certState.certificates.isNotEmpty
                ? certState.certificates.length
                : progressState.certificates.length);

        return RefreshIndicator(
          onRefresh: () async {
            _loadDashboardData();
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 32.0 : 20.0,
                      vertical: 20.0,
                    ),
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
                        if (dashboardData != null)
                          ContinueLearningCardWidget(
                            courseTitle: dashboardData.lastCourseTitle,
                            lessonSubtitle: dashboardData.lastLessonSubtitle,
                            progressRatio: dashboardData.progressRatio,
                            onResume: () {
                              if (dashboardData.lastCourseId != null &&
                                  dashboardData.lastCourseId! > 0) {
                                context.push(
                                    '/courses/${dashboardData.lastCourseId}');
                              } else {
                                context.push('/courses');
                              }
                            },
                            onTakeQuiz: () => context.push('/quizzes'),
                          ),
                        const SizedBox(height: 20),

                        // Quick Stats Row
                        Row(
                          children: [
                            DashboardStatCardWidget(
                              title: 'Enrolled',
                              count: '$enrolledCount Courses',
                              icon: Icons.bookmark_added_rounded,
                              color: AppColors.primary,
                              onTap: () => context.push('/my-courses'),
                            ),
                            const SizedBox(width: 10),
                            DashboardStatCardWidget(
                              title: 'Completed',
                              count: '$completedLessonsCount Lessons',
                              icon: Icons.check_circle_rounded,
                              color: AppColors.secondary,
                              onTap: () => context.push('/progress'),
                            ),
                            const SizedBox(width: 10),
                            DashboardStatCardWidget(
                              title: 'Certificates',
                              count: '$certsEarnedCount Earned',
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
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(AppColors.primary),
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
                                    Icon(Icons.school_outlined,
                                        size: 40, color: AppColors.textMuted),
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
