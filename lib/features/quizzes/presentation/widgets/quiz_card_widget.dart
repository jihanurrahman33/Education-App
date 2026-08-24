import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class QuizCardWidget extends StatelessWidget {
  final String title;
  final String courseName;
  final int questionsCount;
  final int durationMinutes;
  final String passScore;
  final bool isCompleted;
  final String? lastScore;
  final VoidCallback onStartQuiz;

  const QuizCardWidget({
    super.key,
    required this.title,
    required this.courseName,
    required this.questionsCount,
    required this.durationMinutes,
    required this.passScore,
    required this.isCompleted,
    this.lastScore,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.secondary.withValues(alpha: 0.12)
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isCompleted ? 'SCORE: $lastScore' : 'PENDING ASSESSMENT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? AppColors.secondary : AppColors.primary,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '$durationMinutes mins',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              courseName,
              style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$questionsCount Questions • Pass: $passScore',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                CustomButton(
                  text: isCompleted ? 'Retake Quiz' : 'Start Quiz',
                  icon: isCompleted ? Icons.replay_rounded : Icons.play_arrow_rounded,
                  backgroundColor:
                      isCompleted ? AppColors.outlineVariant : AppColors.primary,
                  textColor: isCompleted ? AppColors.onSurface : Colors.white,
                  height: 36,
                  width: 130,
                  onPressed: onStartQuiz,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
