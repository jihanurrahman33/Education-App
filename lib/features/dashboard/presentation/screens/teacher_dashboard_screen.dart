import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../courses/presentation/bloc/course_bloc.dart';
import '../../../courses/presentation/bloc/course_event.dart';
import '../../../courses/presentation/bloc/course_state.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/dashboard_stat_card_widget.dart';
import '../widgets/teacher_verification_banner_widget.dart';

class TeacherDashboardScreen extends StatefulWidget {
  final UserEntity user;

  const TeacherDashboardScreen({super.key, required this.user});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }

  void _loadTeacherData() {
    context.read<DashboardBloc>().add(const LoadTeacherDashboardEvent());
    context.read<CourseBloc>().add(const FetchTeacherCoursesRequested());
  }

  void _checkApprovalAndNavigate(String route) async {
    if (!widget.user.isApprovedTeacher) {
      final check = await ConfirmationDialog.show(
        context,
        title: 'Instructor Approval Required',
        message:
            'Your instructor account is currently pending administrative review. Once approved by an administrator, course creation and quiz publishing will be automatically unlocked.',
        confirmText: 'Check Review Status',
        cancelText: 'Dismiss',
        icon: Icons.hourglass_top_rounded,
      );
      if (check == true && mounted) {
        context.push('/teacher/pending');
      }
      return;
    }
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, dashState) {
        if (dashState.status == DashboardStatus.loading &&
            dashState.teacherData == null) {
          return const TeacherDashboardSkeleton();
        }

        final dashboardData = dashState.teacherData;

        return RefreshIndicator(
          onRefresh: () async => _loadTeacherData(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      isWide ? 32.0 : 20.0,
                      8.0,
                      isWide ? 32.0 : 20.0,
                      24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Teacher Status Warning Banner
                        if (!widget.user.isApprovedTeacher) ...[
                          TeacherVerificationBannerWidget(
                            onTap: () => context.push('/teacher/pending'),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Welcome Instructor Banner
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.roleTeacher, Color(0xFF5B21B6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.roleTeacher.withValues(alpha: 0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Instructor Portal - ${widget.user.fullName}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Create courses, upload video lessons, and build quizzes.',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.cast_for_education_rounded,
                                size: 44,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Teacher Stats Row
                        Row(
                          children: [
                            DashboardStatCardWidget(
                              title: 'Authored',
                              count: '${dashboardData?.authoredCoursesCount ?? 0} Courses',
                              icon: Icons.menu_book_rounded,
                              color: AppColors.roleTeacher,
                            ),
                            const SizedBox(width: 10),
                            DashboardStatCardWidget(
                              title: 'Enrolled',
                              count: '${dashboardData?.totalStudentsEnrolled ?? 0} Students',
                              icon: Icons.groups_rounded,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            DashboardStatCardWidget(
                              title: 'Quizzes',
                              count: '${dashboardData?.activeQuizzesCount ?? 0} Active',
                              icon: Icons.quiz_rounded,
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Teacher Action Bar
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Create New Course',
                                icon: Icons.add_circle_outline_rounded,
                                backgroundColor: AppColors.roleTeacher,
                                onPressed: () =>
                                    _checkApprovalAndNavigate('/teacher/courses/create'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomButton(
                                text: 'Create Quiz',
                                icon: Icons.quiz_outlined,
                                isOutlined: true,
                                backgroundColor: AppColors.roleTeacher,
                                textColor: AppColors.roleTeacher,
                                onPressed: () =>
                                    _checkApprovalAndNavigate('/teacher/quizzes'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        const Text(
                          'My Authored Courses',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        BlocBuilder<CourseBloc, CourseState>(
                          builder: (context, courseState) {
                            if (courseState.status.isLoading &&
                                courseState.teacherCourses.isEmpty) {
                              return const Column(
                                children: [
                                  LoadingSkeletonCard(height: 120, borderRadius: 14),
                                  LoadingSkeletonCard(height: 120, borderRadius: 14),
                                ],
                              );
                            }

                            if (courseState.teacherCourses.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(28.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.school_outlined,
                                        size: 40, color: AppColors.textSecondary),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'You haven\'t published any courses yet.',
                                      style: TextStyle(
                                          fontSize: 14, color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(height: 14),
                                    OutlinedButton.icon(
                                      icon: const Icon(Icons.add_rounded),
                                      label: const Text('Create Course'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        side:
                                            const BorderSide(color: AppColors.primary),
                                      ),
                                      onPressed: () => _checkApprovalAndNavigate(
                                          '/teacher/courses/create'),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: courseState.teacherCourses.length,
                              itemBuilder: (context, index) {
                                final course = courseState.teacherCourses[index];
                                final isPublished = course.isPublished;

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  elevation: 0,
                                  color: AppColors.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: const BorderSide(color: AppColors.border),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: isPublished
                                                    ? AppColors.secondary
                                                        .withValues(alpha: 0.12)
                                                    : AppColors.warning
                                                        .withValues(alpha: 0.12),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                isPublished
                                                    ? 'Published'
                                                    : 'Draft / Pending',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: isPublished
                                                      ? AppColors.secondary
                                                      : AppColors.warning,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit_outlined,
                                                      size: 18,
                                                      color: AppColors.textSecondary),
                                                  tooltip: 'Edit Course',
                                                  onPressed: () =>
                                                      _checkApprovalAndNavigate(
                                                          '/teacher/courses/${course.id}/edit'),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.menu_book_rounded,
                                                      size: 18,
                                                      color: AppColors.primary),
                                                  tooltip: 'Curriculum & Lessons',
                                                  onPressed: () =>
                                                      _checkApprovalAndNavigate(
                                                          '/teacher/courses/${course.id}/curriculum'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          course.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${course.chaptersCount} Chapters • ${course.lessonsCount} Lessons',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
