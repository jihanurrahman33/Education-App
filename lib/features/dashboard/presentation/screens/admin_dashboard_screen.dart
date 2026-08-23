import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../auth/domain/entities/user_entity.dart';

class AdminDashboardScreen extends StatelessWidget {
  final UserEntity user;

  const AdminDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.roleAdmin, Color(0xFFB91C1C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 24),

          // Admin Action Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            children: [
              _buildAdminCard(
                'Pending Teachers',
                'Approve or reject teacher applications',
                Icons.how_to_reg_rounded,
                AppColors.roleTeacher,
                () {},
              ),
              _buildAdminCard(
                'Pending Courses',
                'Review submitted course drafts',
                Icons.rate_review_rounded,
                AppColors.primary,
                () {},
              ),
              _buildAdminCard(
                'User Management',
                'View registered students & teachers',
                Icons.people_outline_rounded,
                AppColors.secondary,
                () {},
              ),
              _buildAdminCard(
                'Analytics & Stats',
                'Platform performance and revenues',
                Icons.insights_rounded,
                AppColors.accent,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
