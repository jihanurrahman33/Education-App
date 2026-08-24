import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class CourseProgressBreakdownCard extends StatelessWidget {
  final String title;
  final int completedLessons;
  final int totalLessons;
  final double progress;
  final bool isEligibleForCertificate;
  final VoidCallback onAction;

  const CourseProgressBreakdownCard({
    super.key,
    required this.title,
    required this.completedLessons,
    required this.totalLessons,
    required this.progress,
    required this.isEligibleForCertificate,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = progress >= 1.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.secondary.withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isDone ? '100% COMPLETE' : '${(progress * 100).toInt()}% IN PROGRESS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDone ? AppColors.secondary : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completedLessons of $totalLessons Lessons Complete',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              if (isEligibleForCertificate)
                const Row(
                  children: [
                    Icon(Icons.verified_rounded, size: 14, color: AppColors.secondary),
                    SizedBox(width: 4),
                    Text(
                      'Certificate Ready',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDone ? AppColors.secondary : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: isEligibleForCertificate ? 'View Verified Certificate' : 'Continue Course',
            icon: isEligibleForCertificate
                ? Icons.workspace_premium_rounded
                : Icons.play_arrow_rounded,
            backgroundColor:
                isEligibleForCertificate ? AppColors.secondary : AppColors.primary,
            height: 38,
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}
