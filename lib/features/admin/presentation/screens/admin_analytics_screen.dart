import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_distribution_bar_widget.dart';
import '../widgets/admin_health_status_row_widget.dart';
import '../widgets/admin_stat_metric_card.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Grid using AdminStatMetricCard
            const Row(
              children: [
                AdminStatMetricCard(
                  label: 'Total Students',
                  value: '480',
                  color: AppColors.primary,
                  trend: '+18% this mo',
                ),
                SizedBox(width: 10),
                AdminStatMetricCard(
                  label: 'Total Instructors',
                  value: '32',
                  color: AppColors.roleTeacher,
                  trend: '3 pending',
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                AdminStatMetricCard(
                  label: 'Active Courses',
                  value: '24',
                  color: AppColors.secondary,
                  trend: '2 pending review',
                ),
                SizedBox(width: 10),
                AdminStatMetricCard(
                  label: 'Certificates Issued',
                  value: '142',
                  color: AppColors.accent,
                  trend: '99.4% pass avg',
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Course Category Distribution',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // Reusable Category Distribution Bars
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  AdminDistributionBarWidget(
                    label: 'Computer Science & Tech',
                    ratio: 0.45,
                    text: '45% (11 courses)',
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 12),
                  AdminDistributionBarWidget(
                    label: 'Design & UI/UX',
                    ratio: 0.25,
                    text: '25% (6 courses)',
                    color: AppColors.secondary,
                  ),
                  SizedBox(height: 12),
                  AdminDistributionBarWidget(
                    label: 'Business & Management',
                    ratio: 0.20,
                    text: '20% (5 courses)',
                    color: AppColors.tertiary,
                  ),
                  SizedBox(height: 12),
                  AdminDistributionBarWidget(
                    label: 'Data Science & AI',
                    ratio: 0.10,
                    text: '10% (2 courses)',
                    color: AppColors.accent,
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

            // Reusable Health Status Rows
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  AdminHealthStatusRowWidget(
                    label: 'REST API Status',
                    status: 'Online (99.98% uptime)',
                    icon: Icons.cloud_done_rounded,
                    statusColor: AppColors.secondary,
                  ),
                  Divider(height: 20),
                  AdminHealthStatusRowWidget(
                    label: 'PostgreSQL Database',
                    status: 'Connected (Lat: 12ms)',
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
    );
  }
}
