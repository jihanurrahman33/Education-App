import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  final List<Map<String, dynamic>> mockQuizzes = const [
    {
      'id': 1,
      'title': 'BLoC State Management Fundamentals',
      'course': 'Full-Stack Modern App Architecture',
      'questionsCount': 10,
      'durationMinutes': 15,
      'passScore': '80%',
      'status': 'Completed',
      'lastScore': '90%',
    },
    {
      'id': 2,
      'title': 'REST API Integration & Dio Error Boundaries',
      'course': 'Full-Stack Modern App Architecture',
      'questionsCount': 12,
      'durationMinutes': 20,
      'passScore': '75%',
      'status': 'Not Started',
      'lastScore': null,
    },
    {
      'id': 3,
      'title': 'Design Tokens & Academic Modernist Aesthetics',
      'course': 'UI/UX Design Systems in Flutter',
      'questionsCount': 8,
      'durationMinutes': 10,
      'passScore': '70%',
      'status': 'Not Started',
      'lastScore': null,
    },
  ];

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
          'Course Quizzes & Assessments',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.primary),
            tooltip: 'My Quiz History',
            onPressed: () => context.push('/quizzes/my-results'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockQuizzes.length,
        itemBuilder: (context, index) {
          final quiz = mockQuizzes[index];
          final isCompleted = quiz['status'] == 'Completed';

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
                          isCompleted ? 'SCORE: ${quiz['lastScore']}' : 'PENDING ASSESSMENT',
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
                            '${quiz['durationMinutes']} mins',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    quiz['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quiz['course'] as String,
                    style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${quiz['questionsCount']} Questions • Pass: ${quiz['passScore']}',
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
                        onPressed: () {
                          context.push('/quizzes/${quiz['id']}/take');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
