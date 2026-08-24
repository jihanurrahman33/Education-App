import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class QuizResultTileWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String scoreText;
  final int percentage;
  final bool passed;

  const QuizResultTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.scoreText,
    required this.percentage,
    required this.passed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: passed
                    ? AppColors.secondary.withValues(alpha: 0.12)
                    : AppColors.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: passed ? AppColors.secondary : AppColors.error,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$subtitle • $date',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: passed ? AppColors.secondary : AppColors.error,
                  ),
                ),
                Text(
                  scoreText,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
