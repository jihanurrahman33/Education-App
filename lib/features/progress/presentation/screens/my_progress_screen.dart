import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class MyProgressScreen extends StatelessWidget {
  const MyProgressScreen({super.key});

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
          'My Learning Progress',
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
            // Overall Stats Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Completion Rate',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '68%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricCol('18', 'Completed Lessons'),
                      Container(height: 24, width: 1, color: Colors.white24),
                      _buildMetricCol('4', 'Enrolled Courses'),
                      Container(height: 24, width: 1, color: Colors.white24),
                      _buildMetricCol('2', 'Certificates'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Course Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            _buildCourseProgressCard(
              title: 'Full-Stack Modern App Architecture',
              completedLessons: 15,
              totalLessons: 20,
              progress: 0.75,
              isEligibleForCertificate: false,
              onAction: () => context.push('/learning/1/lesson/1'),
            ),
            const SizedBox(height: 12),

            _buildCourseProgressCard(
              title: 'UI/UX Design Systems in Flutter',
              completedLessons: 12,
              totalLessons: 12,
              progress: 1.0,
              isEligibleForCertificate: true,
              onAction: () => context.push('/certificates/1'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCol(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildCourseProgressCard({
    required String title,
    required int completedLessons,
    required int totalLessons,
    required double progress,
    required bool isEligibleForCertificate,
    required VoidCallback onAction,
  }) {
    final isDone = progress >= 1.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
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
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.secondary.withValues(alpha: 0.12)
                      : AppColors.primary.withValues(alpha: 0.1),
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
