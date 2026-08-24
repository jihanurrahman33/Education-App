import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StudentGreetingBannerWidget extends StatelessWidget {
  final String studentName;
  final String streakDays;
  final String taskSummary;
  final VoidCallback? onNotificationTap;

  const StudentGreetingBannerWidget({
    super.key,
    required this.studentName,
    this.streakDays = '3 Day Study Streak',
    this.taskSummary = 'You have 2 lessons scheduled for completion today.',
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3B126D), // Royal Deep Purple
            Color(0xFF1E1338), // Dark Purple Canvas
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      streakDays,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
                onPressed: onNotificationTap,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Welcome back, $studentName!',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            taskSummary,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
