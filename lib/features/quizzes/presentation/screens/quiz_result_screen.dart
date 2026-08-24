import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/quiz_score_summary_widget.dart';

class QuizResultScreen extends StatelessWidget {
  final int quizId;
  final int score;
  final int total;
  final int percentage;

  const QuizResultScreen({
    super.key,
    required this.quizId,
    required this.score,
    required this.total,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final isPassed = percentage >= 70;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Quiz Evaluation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: isPassed
                          ? AppColors.secondary.withValues(alpha: 0.12)
                          : AppColors.error.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPassed ? Icons.emoji_events_rounded : Icons.replay_circle_filled_rounded,
                      size: 52,
                      color: isPassed ? AppColors.secondary : AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isPassed ? 'Congratulations! You Passed!' : 'Needs Improvement',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPassed
                        ? 'You have demonstrated strong understanding of the module topics.'
                        : 'Review the lecture materials and try again to meet the 70% passing threshold.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Reusable Score Overview Card Widget
                  QuizScoreSummaryWidget(
                    score: score,
                    total: total,
                    percentage: percentage,
                    isPassed: isPassed,
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    text: isPassed ? 'Back to Dashboard' : 'Retake Quiz',
                    icon: isPassed ? Icons.dashboard_rounded : Icons.replay_rounded,
                    backgroundColor: isPassed ? AppColors.primary : AppColors.primaryContainer,
                    onPressed: () {
                      if (isPassed) {
                        context.go('/dashboard');
                      } else {
                        context.pushReplacement('/quizzes/$quizId/take');
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'View All Quizzes',
                    isOutlined: true,
                    onPressed: () => context.go('/quizzes'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
