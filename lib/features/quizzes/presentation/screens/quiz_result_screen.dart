import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/quiz_entity.dart';

class QuizResultScreen extends StatelessWidget {
  final int quizId;
  final QuizResultEntity? result;
  final int? score;
  final int? total;
  final int? percentage;

  const QuizResultScreen({
    super.key,
    required this.quizId,
    this.result,
    this.score,
    this.total,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final double calculatedScore = result?.scorePercent ??
        (percentage?.toDouble() ?? (total != null && total! > 0 ? (score! / total!) * 100 : 0.0));
    final bool isPassed = result?.passed ?? (calculatedScore >= 70.0);
    final String scoreFormatted = calculatedScore.toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Icon(
                    isPassed
                        ? Icons.check_circle_outline_rounded
                        : Icons.highlight_off_rounded,
                    color: isPassed ? AppColors.success : AppColors.error,
                    size: 72,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isPassed ? 'Congratulations!' : 'Keep Practicing!',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPassed
                        ? 'You passed the assessment with a score of'
                        : 'You did not meet the passing threshold. Your score is',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$scoreFormatted%',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: isPassed ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Answers Breakdown
            if (result?.answers.isNotEmpty ?? false) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Answer Breakdown (${result!.answers.length} Questions)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...result!.answers.map((ans) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ans.isCorrect
                          ? AppColors.success.withValues(alpha: 0.5)
                          : AppColors.error.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        ans.isCorrect
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: ans.isCorrect ? AppColors.success : AppColors.error,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ans.questionText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Selected: ${ans.selectedText}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],

            CustomButton(
              text: 'Back to Dashboard',
              onPressed: () => context.go('/dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
