import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

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
            // KPI Summary Grid
            Row(
              children: [
                _buildKpiCard('Total Students', '480', '+18% this mo', AppColors.primary),
                const SizedBox(width: 10),
                _buildKpiCard('Total Instructors', '32', '3 pending', AppColors.roleTeacher),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildKpiCard('Active Courses', '24', '2 pending review', AppColors.secondary),
                const SizedBox(width: 10),
                _buildKpiCard('Certificates Issued', '142', '99.4% pass avg', AppColors.accent),
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

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildDistributionBar('Computer Science & Tech', 0.45, '45% (11 courses)', AppColors.primary),
                  const SizedBox(height: 12),
                  _buildDistributionBar('Design & UI/UX', 0.25, '25% (6 courses)', AppColors.secondary),
                  const SizedBox(height: 12),
                  _buildDistributionBar('Business & Management', 0.20, '20% (5 courses)', AppColors.tertiary),
                  const SizedBox(height: 12),
                  _buildDistributionBar('Data Science & AI', 0.10, '10% (2 courses)', AppColors.accent),
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
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildHealthRow('REST API Status', 'Online (99.98% uptime)', Icons.cloud_done_rounded, AppColors.secondary),
                  const Divider(height: 20),
                  _buildHealthRow('PostgreSQL Database', 'Connected (Lat: 12ms)', Icons.storage_rounded, AppColors.secondary),
                  const Divider(height: 20),
                  _buildHealthRow('JWT Auth Verification', 'Active (Bearer Valid)', Icons.verified_user_rounded, AppColors.secondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String count, String trend, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(trend, style: const TextStyle(fontSize: 11, color: AppColors.secondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionBar(String label, double ratio, String text, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: AppColors.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthRow(String label, String status, IconData icon, Color statusColor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: statusColor),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
      ],
    );
  }
}
