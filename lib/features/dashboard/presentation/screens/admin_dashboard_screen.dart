import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../../admin/domain/entities/admin_stats_entity.dart';
import '../../../admin/domain/usecases/get_admin_stats_use_case.dart';
import '../../../admin/presentation/widgets/admin_action_card_widget.dart';
import '../../../admin/presentation/widgets/admin_stat_metric_card.dart';
import '../../../auth/domain/entities/user_entity.dart';

class AdminDashboardScreen extends StatefulWidget {
  final UserEntity user;

  const AdminDashboardScreen({super.key, required this.user});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
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
    final pendingTeachers = _stats?.pendingTeachers ?? 0;
    final pendingCourses = _stats?.pendingCourses ?? 0;
    final totalUsers = _stats?.totalUsers ?? 0;

    return RefreshIndicator(
      onRefresh: _fetchStats,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Banner
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.roleAdmin, Color(0xFF991B1B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.roleAdmin.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Administration',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Manage platform teachers, course approvals, and system metrics.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.admin_panel_settings_rounded,
                    size: 48,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Platform Stats Row
            if (_isLoading)
              const Row(
                children: [
                  Expanded(child: LoadingSkeletonCard(height: 85, borderRadius: 12)),
                  SizedBox(width: 10),
                  Expanded(child: LoadingSkeletonCard(height: 85, borderRadius: 12)),
                  SizedBox(width: 10),
                  Expanded(child: LoadingSkeletonCard(height: 85, borderRadius: 12)),
                ],
              )
            else
              Row(
                children: [
                  AdminStatMetricCard(
                    label: 'Pending Teachers',
                    value: '$pendingTeachers',
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 10),
                  AdminStatMetricCard(
                    label: 'Pending Courses',
                    value: '$pendingCourses',
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  AdminStatMetricCard(
                    label: 'Total Users',
                    value: '$totalUsers',
                    color: AppColors.secondary,
                  ),
                ],
              ),
            const SizedBox(height: 24),

            const Text(
              'Management Operations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Admin Action Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                AdminActionCardWidget(
                  title: 'Teacher Approvals',
                  subtitle: '$pendingTeachers pending applications',
                  icon: Icons.how_to_reg_rounded,
                  color: AppColors.warning,
                  onTap: () => context.push('/admin/teachers/pending'),
                ),
                AdminActionCardWidget(
                  title: 'Course Approvals',
                  subtitle: '$pendingCourses pending submissions',
                  icon: Icons.rate_review_rounded,
                  color: AppColors.primary,
                  onTap: () => context.push('/admin/courses/pending'),
                ),
                AdminActionCardWidget(
                  title: 'User Directory',
                  subtitle: 'Manage students & teachers',
                  icon: Icons.people_outline_rounded,
                  color: AppColors.secondary,
                  onTap: () => context.push('/admin/users'),
                ),
                AdminActionCardWidget(
                  title: 'Analytics & Stats',
                  subtitle: 'Platform performance & revenue',
                  icon: Icons.insights_rounded,
                  color: AppColors.tertiary,
                  onTap: () => context.push('/admin/analytics'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
