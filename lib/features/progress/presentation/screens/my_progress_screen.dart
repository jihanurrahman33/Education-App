import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../bloc/progress_bloc.dart';
import '../bloc/progress_event.dart';
import '../bloc/progress_state.dart';
import '../widgets/course_progress_breakdown_card.dart';
import '../widgets/progress_overview_card_widget.dart';

class MyProgressScreen extends StatefulWidget {
  final bool isTab;

  const MyProgressScreen({super.key, this.isTab = false});

  @override
  State<MyProgressScreen> createState() => _MyProgressScreenState();
}

class _MyProgressScreenState extends State<MyProgressScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProgressBloc>().add(const LoadMyProgressEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProgressBloc, ProgressState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppToast.showError(context, state.errorMessage!);
        }
        if (state.successMessage != null) {
          AppToast.showSuccess(context, state.successMessage!);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ProgressStatus.loading && state.myProgress.isEmpty;
        final courses = state.myProgress;
        final certificates = state.certificates;

        int completedLessons = 0;
        double totalPercent = 0.0;

        for (final c in courses) {
          completedLessons += c.completedLessons;
          totalPercent += c.percentage;
        }

        final avgCompletion = courses.isNotEmpty
            ? (totalPercent / courses.length).toInt()
            : 0;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            automaticallyImplyLeading: !widget.isTab,
            leading: widget.isTab
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                    onPressed: () => context.pop(),
                  ),
            title: const Text(
              'My Learning Progress',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
                tooltip: 'Refresh Progress',
                onPressed: () => context.read<ProgressBloc>().add(const LoadMyProgressEvent()),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProgressBloc>().add(const LoadMyProgressEvent());
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isWideScreen ? 32.0 : 20.0,
                        vertical: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isLoading)
                            const LoadingSkeletonCard(height: 120, borderRadius: 16)
                          else
                            ProgressOverviewCardWidget(
                              completionRate: '$avgCompletion%',
                              completedLessons: '$completedLessons',
                              enrolledCourses: '${courses.length}',
                              certificatesCount: '${certificates.length}',
                            ),
                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Course Breakdown',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (certificates.isNotEmpty)
                                TextButton.icon(
                                  icon: const Icon(Icons.workspace_premium_rounded, size: 16),
                                  label: const Text('View Certificates'),
                                  onPressed: () => context.push('/certificates'),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (isLoading)
                            const Column(
                              children: [
                                LoadingSkeletonCard(height: 110, borderRadius: 14),
                                SizedBox(height: 12),
                                LoadingSkeletonCard(height: 110, borderRadius: 14),
                              ],
                            )
                          else if (courses.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(32),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.outlineVariant.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.auto_stories_outlined,
                                    size: 48,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'You are not enrolled in any courses yet.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Browse courses to enroll and track your progress.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => context.push('/courses'),
                                    child: const Text('Explore Courses'),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...courses.map((course) {
                              final progressFraction =
                                  (course.percentage / 100.0).clamp(0.0, 1.0);
                              final isDone = course.isEligibleForCertificate;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: CourseProgressBreakdownCard(
                                  title: course.courseTitle,
                                  completedLessons: course.completedLessons,
                                  totalLessons: course.totalLessons,
                                  progress: progressFraction,
                                  isEligibleForCertificate: isDone,
                                  onAction: () {
                                    if (isDone) {
                                      final existing = certificates.any(
                                        (c) => c.course == course.courseId,
                                      );
                                      if (existing) {
                                        context.push('/certificates');
                                      } else {
                                        context.read<ProgressBloc>().add(
                                              GenerateCertificateProgressEvent(
                                                course.courseId,
                                              ),
                                            );
                                      }
                                    } else {
                                      context.push('/courses/${course.courseId}');
                                    }
                                  },
                                ),
                              );
                            }),
                        ],
                      ),
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
