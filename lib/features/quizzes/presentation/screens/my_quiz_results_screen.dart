import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../widgets/quiz_result_tile_widget.dart';

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

                return QuizResultTileWidget(
                  title: item['title'] as String,
                  subtitle: item['course'] as String,
                  date: item['date'] as String,
                  scoreText: '${item['score']}/${item['total']}',
                  percentage: item['percentage'] as int,
                  passed: passed,
                );
              },
            ),
    );
  }
}
