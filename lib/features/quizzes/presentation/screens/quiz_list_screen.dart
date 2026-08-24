import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(const FetchQuizzesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes & Assessments'),
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state.status.isLoading && state.quizzes.isEmpty) {
            return const LoadingView(message: 'Loading quizzes...');
          }

          if (state.status.isError && state.quizzes.isEmpty) {
            return ErrorView(
              message: state.errorMessage ?? 'Failed to load quizzes',
              onRetry: () => context.read<QuizBloc>().add(const FetchQuizzesRequested()),
            );
          }

          if (state.quizzes.isEmpty) {
            return const Center(
              child: Text(
                'No quizzes available.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<QuizBloc>().add(const FetchQuizzesRequested());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.quizzes.length,
              itemBuilder: (context, index) {
                final quiz = state.quizzes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.quiz_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      quiz.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (quiz.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            quiz.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          'Pass score: ${quiz.passScorePercent}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {
                      context.push('/quizzes/${quiz.id}/take');
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
