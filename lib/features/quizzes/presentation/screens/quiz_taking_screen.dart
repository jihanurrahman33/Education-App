import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/quiz_question_card_widget.dart';

class QuizTakingScreen extends StatefulWidget {
  final int quizId;

  const QuizTakingScreen({super.key, required this.quizId});

  @override
  State<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  int _remainingSeconds = 600; // 10 minutes
  Timer? _timer;

  final List<Map<String, dynamic>> _questions = const [
    {
      'id': 1,
      'question':
          'In Clean Architecture, which layer is strictly forbidden from importing external presentation or data dependencies?',
      'choices': [
        {'id': 1, 'text': 'Presentation Layer'},
        {'id': 2, 'text': 'Domain Layer'},
        {'id': 3, 'text': 'Data Layer'},
        {'id': 4, 'text': 'Core Infrastructure Layer'},
      ],
      'correctChoiceId': 2,
    },
    {
      'id': 2,
      'question':
          'What is the purpose of using Dio interceptors when making authenticated REST API calls?',
      'choices': [
        {'id': 1, 'text': 'To automatically attach Bearer JWT tokens to outbound requests'},
        {'id': 2, 'text': 'To render widgets directly from HTML payloads'},
        {'id': 3, 'text': 'To convert JSON directly into SQLite tables'},
        {'id': 4, 'text': 'To replace flutter_bloc state machines'},
      ],
      'correctChoiceId': 1,
    },
    {
      'id': 3,
      'question':
          'When does a student become eligible to generate their official course certificate?',
      'choices': [
        {'id': 1, 'text': 'Immediately after paying enrollment fees'},
        {'id': 2, 'text': 'After completing at least 50% of the lessons'},
        {'id': 3, 'text': 'Only after reaching 100% complete progress on all course lessons'},
        {'id': 4, 'text': 'When the teacher sends an email invite'},
      ],
      'correctChoiceId': 3,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _onSubmitQuiz();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onSubmitQuiz() async {
    final unanswered = _questions.length - _selectedAnswers.length;

    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Submit Quiz Answers?',
      message: unanswered > 0
          ? 'You have $unanswered unanswered questions remaining. Are you sure you want to submit your final answers?'
          : 'Are you ready to submit your assessment and view your evaluated score?',
      confirmText: 'Submit Quiz',
      icon: Icons.check_circle_rounded,
    );

    if (confirmed == true && mounted) {
      int score = 0;
      for (var i = 0; i < _questions.length; i++) {
        final q = _questions[i];
        if (_selectedAnswers[i] == q['correctChoiceId']) {
          score++;
        }
      }

      final percentage = ((score / _questions.length) * 100).toInt();

      context.pushReplacement(
        '/quizzes/${widget.quizId}/result?score=$score&total=${_questions.length}&percentage=$percentage',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentQuestionIndex];
    final selectedChoiceId = _selectedAnswers[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.onSurface),
          onPressed: () async {
            final exit = await ConfirmationDialog.show(
              context,
              title: 'Exit Quiz?',
              message: 'Your current progress on this quiz will not be saved.',
              confirmText: 'Exit',
              confirmColor: AppColors.error,
            );
            if (exit == true && context.mounted) {
              context.pop();
            }
          },
        ),
        title: Text(
          'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _remainingSeconds < 120
                  ? AppColors.error.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: _remainingSeconds < 120 ? AppColors.error : AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  _formattedTime,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _remainingSeconds < 120 ? AppColors.error : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Question Progress Bar
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              minHeight: 4,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: QuizQuestionCardWidget(
                  questionNumber: _currentQuestionIndex + 1,
                  totalQuestions: _questions.length,
                  questionText: currentQ['question'] as String,
                  choices: currentQ['choices'] as List<dynamic>,
                  selectedChoiceId: selectedChoiceId,
                  onSelectChoice: (choiceId) {
                    setState(() {
                      _selectedAnswers[_currentQuestionIndex] = choiceId;
                    });
                  },
                ),
              ),
            ),

            // Bottom Navigation Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
              ),
              child: Row(
                children: [
                  if (_currentQuestionIndex > 0)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentQuestionIndex--;
                        });
                      },
                      child: const Text('Previous'),
                    ),
                  const Spacer(),
                  if (_currentQuestionIndex < _questions.length - 1)
                    CustomButton(
                      text: 'Next Question',
                      width: 150,
                      onPressed: () {
                        setState(() {
                          _currentQuestionIndex++;
                        });
                      },
                    )
                  else
                    CustomButton(
                      text: 'Submit Quiz',
                      backgroundColor: AppColors.secondary,
                      width: 150,
                      onPressed: _onSubmitQuiz,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
