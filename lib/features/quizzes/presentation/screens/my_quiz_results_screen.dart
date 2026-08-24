import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class MyQuizResultsScreen extends StatelessWidget {
  const MyQuizResultsScreen({super.key});

  final List<Map<String, dynamic>> mockHistory = const [
    {
      'id': 1,
      'title': 'BLoC State Management Fundamentals',
      'course': 'Full-Stack Modern App Architecture',
      'date': 'Aug 22, 2026',
      'score': 9,
      'total': 10,
      'percentage': 90,
      'passed': true,
    },
    {
      'id': 2,
      'title': 'Dart Generics & Collections',
      'course': 'Advanced Dart Programming',
      'date': 'Aug 18, 2026',
      'score': 8,
      'total': 10,
      'percentage': 80,
      'passed': true,
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
          'My Assessment History',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: mockHistory.isEmpty
          ? EmptyStateWidget(
              icon: Icons.history_edu_rounded,
              title: 'No Quiz Submissions',
              message: 'Take your first quiz assessment to view evaluation records here.',
              actionText: 'View Quizzes',
              onAction: () => context.push('/quizzes'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockHistory.length,
              itemBuilder: (context, index) {
                final item = mockHistory[index];
                final passed = item['passed'] as bool;

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
                                item['title'] as String,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item['course']} • ${item['date']}',
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
                              '${item['percentage']}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: passed ? AppColors.secondary : AppColors.error,
                              ),
                            ),
                            Text(
                              '${item['score']}/${item['total']}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
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
