import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/quiz_card_widget.dart';

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

          return QuizCardWidget(
            title: quiz['title'] as String,
            courseName: quiz['course'] as String,
            questionsCount: quiz['questionsCount'] as int,
            durationMinutes: quiz['durationMinutes'] as int,
            passScore: quiz['passScore'] as String,
            isCompleted: isCompleted,
            lastScore: quiz['lastScore'] as String?,
            onStartQuiz: () => context.push('/quizzes/${quiz['id']}/take'),
          );
        },
      ),
    );
  }
}
