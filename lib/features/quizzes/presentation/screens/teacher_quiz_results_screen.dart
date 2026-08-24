import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

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
            // Overview Stats
            Row(
              children: [
                _buildStatBox('Total Attempts', '18', AppColors.primary),
                const SizedBox(width: 10),
                _buildStatBox('Pass Rate', '88%', AppColors.secondary),
                const SizedBox(width: 10),
                _buildStatBox('Avg Score', '83%', AppColors.accent),
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

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.surfaceContainer,
                          child: Text(
                            (sub['student'] as String)[0],
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sub['student'] as String,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                '${sub['email']} • ${sub['date']}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${sub['percentage']}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: passed ? AppColors.secondary : AppColors.error,
                              ),
                            ),
                            Text(
                              sub['score'] as String,
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
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
