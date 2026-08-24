import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';
import '../widgets/question_card_widget.dart';

class TakeQuizScreen extends StatefulWidget {
  final int quizId;

  const TakeQuizScreen({super.key, required this.quizId});

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(TakeQuizRequested(widget.quizId));
  }

  void _onSubmit() {
    final state = context.read<QuizBloc>().state;
    final totalQuestions = state.selectedQuiz?.questions.length ?? 0;
    final answered = state.selectedAnswers.length;

    if (answered < totalQuestions) {
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: const Text('Incomplete Quiz'),
          content: Text(
            'You have answered $answered of $totalQuestions questions. Do you want to submit anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Keep Working'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                context.read<QuizBloc>().add(SubmitQuizRequested(widget.quizId));
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );
    } else {
      context.read<QuizBloc>().add(SubmitQuizRequested(widget.quizId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state.status.isSubmitted && state.submissionResult != null) {
            context.pushReplacement(
              '/quizzes/${widget.quizId}/result',
              extra: state.submissionResult,
            );
          } else if (state.status.isError && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status.isLoading && state.selectedQuiz == null) {
            return const LoadingView(message: 'Loading quiz questions...');
          }

          if (state.status.isError && state.selectedQuiz == null) {
            return ErrorView(
              message: state.errorMessage ?? 'Failed to load quiz',
              onRetry: () =>
                  context.read<QuizBloc>().add(TakeQuizRequested(widget.quizId)),
            );
          }

          final quiz = state.selectedQuiz;
          if (quiz == null) {
            return const Center(child: Text('Quiz not found'));
          }

          final questions = quiz.questions;
          if (questions.isEmpty) {
            return const Center(
              child: Text(
                'No questions added to this quiz yet.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        color: AppColors.surface,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                quiz.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              '${state.selectedAnswers.length}/${questions.length} Answered',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: isWide ? 24.0 : 16.0,
                            vertical: 16.0,
                          ),
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            final question = questions[index];
                            return QuestionCardWidget(
                              question: question,
                              questionIndex: index,
                              selectedChoiceId: state.selectedAnswers[question.id],
                              onChoiceSelected: (choiceId) {
                                context.read<QuizBloc>().add(
                                      SelectQuizAnswer(
                                        questionId: question.id,
                                        choiceId: choiceId,
                                      ),
                                    );
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          border: Border(top: BorderSide(color: AppColors.border)),
                        ),
                        child: CustomButton(
                          text: 'Submit Quiz',
                          isLoading: state.status.isSubmitting,
                          onPressed: _onSubmit,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
