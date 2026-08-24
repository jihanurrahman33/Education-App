import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/quiz_result_tile_widget.dart';
import '../widgets/quiz_submission_stat_box.dart';

class TeacherQuizResultsScreen extends StatelessWidget {
  final int quizId;

  const TeacherQuizResultsScreen({super.key, required this.quizId});

  final List<Map<String, dynamic>> mockSubmissions = const [
    {
      'student': 'John Doe',
      'email': 'john@example.com',
      'score': '9/10',
      'percentage': 90,
      'date': 'Aug 24, 2026',
      'passed': true,
    },
    {
      'student': 'Sarah Connor',
      'email': 'sarah@example.com',
      'score': '10/10',
      'percentage': 100,
      'date': 'Aug 23, 2026',
      'passed': true,
    },
    {
      'student': 'Alex Murphy',
      'email': 'alex@example.com',
      'score': '6/10',
      'percentage': 60,
      'date': 'Aug 22, 2026',
      'passed': false,
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
          'Student Quiz Submissions',
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
            // Reusable Overview Stats Boxes
            const Row(
              children: [
                QuizSubmissionStatBox(
                  label: 'Total Attempts',
                  value: '18',
                  color: AppColors.primary,
                ),
                SizedBox(width: 10),
                QuizSubmissionStatBox(
                  label: 'Pass Rate',
                  value: '88%',
                  color: AppColors.secondary,
                ),
                SizedBox(width: 10),
                QuizSubmissionStatBox(
                  label: 'Avg Score',
                  value: '83%',
                  color: AppColors.accent,
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Recent Student Attempts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockSubmissions.length,
              itemBuilder: (context, index) {
                final sub = mockSubmissions[index];
                final passed = sub['passed'] as bool;

                return QuizResultTileWidget(
                  title: sub['student'] as String,
                  subtitle: sub['email'] as String,
                  date: sub['date'] as String,
                  scoreText: sub['score'] as String,
                  percentage: sub['percentage'] as int,
                  passed: passed,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
