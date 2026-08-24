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
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department_rounded, size: 14, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      streakDays,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                onPressed: onNotificationTap,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Welcome back, $studentName!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            taskSummary,
            style: const TextStyle(
              color: AppColors.onPrimaryContainer,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
