import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';
import '../widgets/quiz_result_tile_widget.dart';

class MyQuizResultsScreen extends StatefulWidget {
  const MyQuizResultsScreen({super.key});

  @override
  State<MyQuizResultsScreen> createState() => _MyQuizResultsScreenState();
}

class _MyQuizResultsScreenState extends State<MyQuizResultsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(const FetchMyQuizResultsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'My Assessment History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
            onPressed: () =>
                context.read<QuizBloc>().add(const FetchMyQuizResultsRequested()),
          ),
        ],
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          final isLoading = state.status.isLoading && state.myResults.isEmpty;

          if (isLoading) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  itemBuilder: (context, index) =>
                      const LoadingSkeletonCard(height: 90, borderRadius: 14),
                ),
              ),
            );
          }

          if (state.myResults.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<QuizBloc>().add(const FetchMyQuizResultsRequested());
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: EmptyStateWidget(
                      icon: Icons.history_edu_rounded,
                      title: 'No Quiz Submissions',
                      message:
                          'Take your first quiz assessment to view evaluation records here.',
                      actionText: 'View Quizzes',
                      onAction: () => context.push('/quizzes'),
                    ),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<QuizBloc>()
                          .add(const FetchMyQuizResultsRequested());
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 24.0 : 16.0,
                        vertical: 16.0,
                      ),
                      itemCount: state.myResults.length,
                      itemBuilder: (context, index) {
                        final item = state.myResults[index];
                        final percentage = item.scorePercent.round();
                        final dateStr = item.submittedAt != null
                            ? '${item.submittedAt!.day}/${item.submittedAt!.month}/${item.submittedAt!.year}'
                            : 'Recent';

                        return QuizResultTileWidget(
                          title: 'Quiz Assessment #${item.quizId}',
                          subtitle: 'Result: ${item.passed ? "Passed" : "Needs Review"}',
                          date: dateStr,
                          scoreText: '$percentage%',
                          percentage: percentage,
                          passed: item.passed,
                        );
                      },
                    ),
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
