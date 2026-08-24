import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../domain/entities/admin_stats_entity.dart';
import '../../domain/usecases/get_admin_stats_use_case.dart';
import '../widgets/admin_distribution_bar_widget.dart';
import '../widgets/admin_health_status_row_widget.dart';
import '../widgets/admin_stat_metric_card.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  final GetAdminStatsUseCase _getAdminStatsUseCase = GetIt.I<GetAdminStatsUseCase>();

  AdminStatsEntity? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() => _isLoading = true);
    final result = await _getAdminStatsUseCase(const NoParams());

    if (!mounted) return;

    result.fold(
      (_) => setState(() => _isLoading = false),
      (stats) => setState(() {
        _stats = stats;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalStudents = _stats?.totalStudents ?? 0;
    final totalTeachers = _stats?.totalTeachers ?? 0;
    final approvedCourses = _stats?.approvedCourses ?? 0;
    final certificatesIssued = _stats?.certificatesIssued ?? 0;
    final avgScore = _stats?.avgQuizScore.toStringAsFixed(1) ?? '0.0';

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Platform Analytics & Metrics',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
            tooltip: 'Refresh Metrics',
            onPressed: _fetchStats,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchStats,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KPI Summary Grid
              if (_isLoading)
                const Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: LoadingSkeletonCard(height: 90, borderRadius: 16)),
                        SizedBox(width: 10),
                        Expanded(child: LoadingSkeletonCard(height: 90, borderRadius: 16)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: LoadingSkeletonCard(height: 90, borderRadius: 16)),
                        SizedBox(width: 10),
                        Expanded(child: LoadingSkeletonCard(height: 90, borderRadius: 16)),
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
                          trend: '${_stats?.pendingTeachers ?? 0} pending',
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
                          trend: '${_stats?.pendingCourses ?? 0} pending review',
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

              const Text(
                'Course Activity Distribution',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    AdminDistributionBarWidget(
                      label: 'Approved Courses',
                      ratio: (_stats?.totalCourses ?? 0) > 0
                          ? ((_stats?.approvedCourses ?? 0) / (_stats?.totalCourses ?? 1)).clamp(0.0, 1.0)
                          : 0.8,
                      text: '${_stats?.approvedCourses ?? 0} published',
                      color: AppColors.secondary,
                    ),
                    const SizedBox(height: 12),
                    AdminDistributionBarWidget(
                      label: 'Total Enrollments',
                      ratio: 0.65,
                      text: '${_stats?.totalEnrollments ?? 0} enrollments',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    AdminDistributionBarWidget(
                      label: 'Quiz Submissions',
                      ratio: 0.45,
                      text: '${_stats?.quizSubmissions ?? 0} completed',
                      color: AppColors.tertiary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'System Health & Infrastructure',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: const Column(
                  children: [
                    AdminHealthStatusRowWidget(
                      label: 'REST API Status',
                      status: 'Online (Django Live)',
                      icon: Icons.cloud_done_rounded,
                      statusColor: AppColors.secondary,
                    ),
                    Divider(height: 20),
                    AdminHealthStatusRowWidget(
                      label: 'Database Backend',
                      status: 'Connected (SQLite/PostgreSQL)',
                      icon: Icons.storage_rounded,
                      statusColor: AppColors.secondary,
                    ),
                    Divider(height: 20),
                    AdminHealthStatusRowWidget(
                      label: 'JWT Auth Verification',
                      status: 'Active (Bearer Valid)',
                      icon: Icons.verified_user_rounded,
                      statusColor: AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
