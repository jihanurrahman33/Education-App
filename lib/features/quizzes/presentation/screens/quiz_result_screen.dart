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
        (percentage?.toDouble() ??
            (total != null && total! > 0 ? (score! / total!) * 100 : 0.0));
    final bool isPassed = result?.passed ?? (calculatedScore >= 70.0);
    final String scoreFormatted = calculatedScore.toStringAsFixed(1);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Quiz Results',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 768;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 32.0 : 20.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Score Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28.0),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: (isPassed
                                    ? AppColors.secondary
                                    : AppColors.error)
                                .withValues(alpha: 0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: (isPassed
                                      ? AppColors.secondary
                                      : AppColors.error)
                                  .withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPassed
                                  ? Icons.workspace_premium_rounded
                                  : Icons.highlight_off_rounded,
                              color: isPassed
                                  ? AppColors.secondary
                                  : AppColors.error,
                              size: 56,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isPassed
                                ? 'Congratulations! You Passed!'
                                : 'Keep Practicing!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isPassed
                                ? 'You achieved the passing score requirement for this module.'
                                : 'You scored below the passing threshold of 70%. Review the material and try again.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '$scoreFormatted%',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: isPassed
                                  ? AppColors.secondary
                                  : AppColors.error,
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
                            fontSize: 15,
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
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: ans.isCorrect
                                  ? AppColors.secondary.withValues(alpha: 0.4)
                                  : AppColors.error.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                ans.isCorrect
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color: ans.isCorrect
                                    ? AppColors.secondary
                                    : AppColors.error,
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
                                        color: AppColors.textPrimary,
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
                      icon: Icons.dashboard_rounded,
                      onPressed: () => context.go('/dashboard'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
