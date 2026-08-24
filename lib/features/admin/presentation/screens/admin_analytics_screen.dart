import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';
import '../widgets/admin_action_card_widget.dart';
import '../widgets/admin_distribution_bar_widget.dart';
import '../widgets/admin_stat_metric_card.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  final bool isTab;

  const AdminAnalyticsScreen({super.key, this.isTab = false});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const LoadAdminDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: !widget.isTab,
        leading: widget.isTab
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              ),
        title: const Text(
          'Platform Analytics & Metrics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
            tooltip: 'Refresh Metrics',
            onPressed: () =>
                context.read<AdminBloc>().add(const LoadAdminDashboardEvent()),
          ),
        ],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          final isLoading =
              state.status == AdminStatus.loading && state.dashboardStats == null;
          final stats = state.dashboardStats;
          final topCourses = state.topCourses;

          final totalStudents = stats?.totalStudents ?? 0;
          final totalTeachers = stats?.totalTeachers ?? 0;
          final approvedCourses = stats?.approvedCourses ?? 0;
          final certificatesIssued = stats?.certificatesIssued ?? 0;
          final avgScore = stats?.avgQuizScore.toStringAsFixed(1) ?? '0.0';
          final pendingTeachers = stats?.pendingTeachers ?? 0;
          final pendingCourses = stats?.pendingCourses ?? 0;
          final totalUsers = stats?.totalUsers ?? 0;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<AdminBloc>()
                          .add(const LoadAdminDashboardEvent());
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 32.0 : 20.0,
                        vertical: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // KPI Summary Grid
                          if (isLoading)
                            const Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: LoadingSkeletonCard(
                                            height: 90, borderRadius: 16)),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: LoadingSkeletonCard(
                                            height: 90, borderRadius: 16)),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                        child: LoadingSkeletonCard(
                                            height: 90, borderRadius: 16)),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: LoadingSkeletonCard(
                                            height: 90, borderRadius: 16)),
                                  ],
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                Row(
                                  children: [
                                    AdminStatMetricCard(
                                      label: 'Total Students',
                                      value: '$totalStudents',
                                      color: AppColors.primary,
                                      trend: 'Active Learners',
                                    ),
                                    const SizedBox(width: 10),
                                    AdminStatMetricCard(
                                      label: 'Total Instructors',
                                      value: '$totalTeachers',
                                      color: AppColors.roleTeacher,
                                      trend: '$pendingTeachers pending',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    AdminStatMetricCard(
                                      label: 'Active Courses',
                                      value: '$approvedCourses',
                                      color: AppColors.secondary,
                                      trend: '$pendingCourses pending review',
                                    ),
                                    const SizedBox(width: 10),
                                    AdminStatMetricCard(
                                      label: 'Certificates Issued',
                                      value: '$certificatesIssued',
                                      color: AppColors.accent,
                                      trend: '$avgScore% pass avg',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          const SizedBox(height: 24),

                          // Moderation & Administrative Hub
                          const Text(
                            'Administrative Moderation Hub',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),

                          GridView.count(
                            crossAxisCount: isWide ? 3 : 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: isWide ? 1.8 : 1.35,
                            children: [
                              AdminActionCardWidget(
                                title: 'Approve Teachers',
                                subtitle: '$pendingTeachers applications',
                                icon: Icons.how_to_reg_rounded,
                                color: AppColors.roleTeacher,
                                onTap: () => context.push('/admin/teachers/pending'),
                              ),
                              AdminActionCardWidget(
                                title: 'Review Courses',
                                subtitle: '$pendingCourses awaiting moderation',
                                icon: Icons.fact_check_rounded,
                                color: AppColors.secondary,
                                onTap: () => context.push('/admin/courses/pending'),
                              ),
                              AdminActionCardWidget(
                                title: 'User Directory',
                                subtitle: '$totalUsers total accounts',
                                icon: Icons.manage_accounts_rounded,
                                color: AppColors.primary,
                                onTap: () => context.push('/admin/users'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Top Courses Leaderboard
                          const Text(
                            'Top Courses by Enrollment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),

                          if (isLoading)
                            const LoadingSkeletonCard(
                                height: 160, borderRadius: 16)
                          else if (topCourses.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Center(
                                child: Text(
                                  'No course enrollment data available yet.',
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13),
                                ),
                              ),
                            )
                          else
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: topCourses.length.clamp(0, 5),
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final course = topCourses[index];
                                  final isTopRank = index == 0;

                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: isTopRank
                                          ? AppColors.primary
                                          : AppColors.surfaceContainerHigh,
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isTopRank
                                              ? Colors.white
                                              : AppColors.onSurface,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      course.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Teacher: ${course.teacher}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${course.enrollments} Enrolled',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 24),

                          // Learning & Curriculum Engagement Overview
                          const Text(
                            'Platform Learning Distribution',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              children: [
                                AdminDistributionBarWidget(
                                  label: 'Approved Courses',
                                  ratio: (stats?.totalCourses ?? 0) > 0
                                      ? ((stats?.approvedCourses ?? 0) /
                                              (stats?.totalCourses ?? 1))
                                          .clamp(0.0, 1.0)
                                      : 0.8,
                                  text:
                                      '${stats?.approvedCourses ?? 0} / ${stats?.totalCourses ?? 0} published',
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(height: 14),
                                AdminDistributionBarWidget(
                                  label: 'Total Enrollments',
                                  ratio: (stats?.totalEnrollments ?? 0) > 0
                                      ? ((stats?.totalEnrollments ?? 0) /
                                              ((stats?.totalStudents ?? 1) * 3))
                                          .clamp(0.0, 1.0)
                                      : 0.5,
                                  text:
                                      '${stats?.totalEnrollments ?? 0} student enrollments',
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 14),
                                AdminDistributionBarWidget(
                                  label: 'Quiz Evaluations',
                                  ratio: (stats?.quizSubmissions ?? 0) > 0
                                      ? 0.75
                                      : 0.0,
                                  text:
                                      '${stats?.quizSubmissions ?? 0} submissions ($avgScore% avg score)',
                                  color: AppColors.tertiary,
                                ),
                                const SizedBox(height: 14),
                                AdminDistributionBarWidget(
                                  label: 'Certificates Awarded',
                                  ratio: (stats?.certificatesIssued ?? 0) > 0
                                      ? ((stats?.certificatesIssued ?? 0) /
                                              ((stats?.totalEnrollments ?? 1) + 1))
                                          .clamp(0.0, 1.0)
                                      : 0.3,
                                  text:
                                      '${stats?.certificatesIssued ?? 0} credentials issued',
                                  color: AppColors.accent,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
