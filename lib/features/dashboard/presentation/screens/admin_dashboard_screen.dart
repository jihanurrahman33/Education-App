import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../../admin/presentation/bloc/admin_bloc.dart';
import '../../../admin/presentation/bloc/admin_event.dart';
import '../../../admin/presentation/bloc/admin_state.dart';
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
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    context.read<AdminBloc>().add(const LoadAdminDashboardEvent());
    context.read<AdminBloc>().add(const LoadPendingTeachersEvent());
    context.read<AdminBloc>().add(const LoadPendingCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        final stats = state.dashboardStats;
        final isLoading =
            state.status == AdminStatus.loading && stats == null;
        final pendingTeachers = stats?.pendingTeachers ??
            (state.pendingTeachers.isNotEmpty
                ? state.pendingTeachers.length
                : 0);
        final pendingCourses = stats?.pendingCourses ??
            (state.pendingCourses.isNotEmpty
                ? state.pendingCourses.length
                : 0);
        final totalUsers = stats?.totalUsers ??
            (state.users.isNotEmpty ? state.users.length : 0);

        return RefreshIndicator(
          onRefresh: () async => _loadDashboardData(),
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
                                color:
                                    AppColors.roleAdmin.withValues(alpha: 0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                        if (isLoading)
                          const Row(
                            children: [
                              Expanded(
                                  child: LoadingSkeletonCard(
                                      height: 85, borderRadius: 12)),
                              SizedBox(width: 10),
                              Expanded(
                                  child: LoadingSkeletonCard(
                                      height: 85, borderRadius: 12)),
                              SizedBox(width: 10),
                              Expanded(
                                  child: LoadingSkeletonCard(
                                      height: 85, borderRadius: 12)),
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
                          crossAxisCount: isWide ? 4 : 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: isWide ? 1.4 : 1.05,
                          children: [
                            AdminActionCardWidget(
                              title: 'Teacher Approvals',
                              subtitle: '$pendingTeachers pending applications',
                              icon: Icons.how_to_reg_rounded,
                              color: AppColors.warning,
                              onTap: () =>
                                  context.push('/admin/teachers/pending'),
                            ),
                            AdminActionCardWidget(
                              title: 'Course Approvals',
                              subtitle: '$pendingCourses pending submissions',
                              icon: Icons.rate_review_rounded,
                              color: AppColors.primary,
                              onTap: () =>
                                  context.push('/admin/courses/pending'),
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
                              subtitle: 'Platform performance & metrics',
                              icon: Icons.insights_rounded,
                              color: AppColors.tertiary,
                              onTap: () => context.push('/admin/analytics'),
                            ),
                          ],
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
