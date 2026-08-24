import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class QuizScoreSummaryWidget extends StatelessWidget {
  final int score;
  final int total;
  final int percentage;
  final bool isPassed;

  const QuizScoreSummaryWidget({
    super.key,
    required this.score,
    required this.total,
    required this.percentage,
    required this.isPassed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: isPassed ? AppColors.secondary : AppColors.error,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your Final Score: $score / $total Questions Correct',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric('Passing Grade', '70%'),
              _buildMetric('Questions', '$total'),
              _buildMetric('Result', isPassed ? 'PASSED' : 'FAILED'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
