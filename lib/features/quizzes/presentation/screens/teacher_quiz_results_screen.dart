import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';
import '../widgets/quiz_result_tile_widget.dart';
import '../widgets/quiz_submission_stat_box.dart';

class TeacherQuizResultsScreen extends StatefulWidget {
  final int quizId;

  const TeacherQuizResultsScreen({super.key, required this.quizId});

  @override
  State<TeacherQuizResultsScreen> createState() => _TeacherQuizResultsScreenState();
}

class _TeacherQuizResultsScreenState extends State<TeacherQuizResultsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(FetchTeacherQuizResultsRequested(widget.quizId));
  }

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
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state.status.isLoading && state.teacherResults.isEmpty) {
            return const LoadingView(message: 'Loading student submissions...');
          }

          if (state.status.isError && state.teacherResults.isEmpty) {
            return ErrorView(
              message: state.errorMessage ?? 'Failed to load submissions',
              onRetry: () => context.read<QuizBloc>().add(
                    FetchTeacherQuizResultsRequested(widget.quizId),
                  ),
            );
          }

          final results = state.teacherResults;
          final totalAttempts = results.length;
          final passedAttempts = results.where((r) => r.passed).length;
          final passRate = totalAttempts > 0
              ? ((passedAttempts / totalAttempts) * 100).toStringAsFixed(0)
              : '0';
          final avgScore = totalAttempts > 0
              ? (results.map((r) => r.scorePercent).reduce((a, b) => a + b) / totalAttempts)
                  .toStringAsFixed(0)
              : '0';

          return RefreshIndicator(
            onRefresh: () async {
              context.read<QuizBloc>().add(
                    FetchTeacherQuizResultsRequested(widget.quizId),
                  );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      QuizSubmissionStatBox(
                        label: 'Total Attempts',
                        value: '$totalAttempts',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      QuizSubmissionStatBox(
                        label: 'Pass Rate',
                        value: '$passRate%',
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 10),
                      QuizSubmissionStatBox(
                        label: 'Avg Score',
                        value: '$avgScore%',
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Student Attempts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (results.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: Text(
                          'No students have submitted this quiz yet.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final res = results[index];
                        return QuizResultTileWidget(
                          title: 'Student #${res.studentId}',
                          subtitle: res.submittedAt != null
                              ? res.submittedAt!.toLocal().toString().split('.')[0]
                              : 'Recent submission',
                          date: res.submittedAt != null
                              ? '${res.submittedAt!.day}/${res.submittedAt!.month}/${res.submittedAt!.year}'
                              : '',
                          scoreText: '${res.scorePercent.toStringAsFixed(0)}%',
                          percentage: res.scorePercent.round(),
                          passed: res.passed,
                        );
                      },
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
