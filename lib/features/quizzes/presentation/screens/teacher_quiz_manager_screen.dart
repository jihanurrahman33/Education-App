import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class TeacherQuizManagerScreen extends StatefulWidget {
  final int? quizId;

  const TeacherQuizManagerScreen({super.key, this.quizId});

  @override
  State<TeacherQuizManagerScreen> createState() => _TeacherQuizManagerScreenState();
}

class _TeacherQuizManagerScreenState extends State<TeacherQuizManagerScreen> {
  final _titleController = TextEditingController();
  final _durationController = TextEditingController(text: '15');
  final _passScoreController = TextEditingController(text: '75');

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which layer in Clean Architecture defines the Repository Interface contracts?',
      'choices': [
        {'text': 'Data Layer', 'isCorrect': false},
        {'text': 'Domain Layer', 'isCorrect': true},
        {'text': 'Presentation Layer', 'isCorrect': false},
        {'text': 'Core Layer', 'isCorrect': false},
      ],
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _passScoreController.dispose();
    super.dispose();
  }

  void _showAddQuestionDialog() {
    final qController = TextEditingController();
    final c1 = TextEditingController(text: 'Choice A');
    final c2 = TextEditingController(text: 'Choice B');
    final c3 = TextEditingController(text: 'Choice C');
    final c4 = TextEditingController(text: 'Choice D');
    int correctIndex = 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Question & Choices', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: qController,
                  decoration: const InputDecoration(labelText: 'Question Text', hintText: 'Enter question...'),
                ),
                const SizedBox(height: 16),
                const Text('Choices (Select correct answer):', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(height: 8),
                _buildChoiceRow(0, c1, correctIndex, (val) => setDialogState(() => correctIndex = val)),
                _buildChoiceRow(1, c2, correctIndex, (val) => setDialogState(() => correctIndex = val)),
                _buildChoiceRow(2, c3, correctIndex, (val) => setDialogState(() => correctIndex = val)),
                _buildChoiceRow(3, c4, correctIndex, (val) => setDialogState(() => correctIndex = val)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.roleTeacher),
              onPressed: () {
                if (qController.text.trim().isNotEmpty) {
                  setState(() {
                    _questions.add({
                      'question': qController.text.trim(),
                      'choices': [
                        {'text': c1.text, 'isCorrect': correctIndex == 0},
                        {'text': c2.text, 'isCorrect': correctIndex == 1},
                        {'text': c3.text, 'isCorrect': correctIndex == 2},
                        {'text': c4.text, 'isCorrect': correctIndex == 3},
                      ],
                    });
                  });
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Add Question', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceRow(int index, TextEditingController ctrl, int currentCorrect, ValueChanged<int> onSelect) {
    final isSelected = currentCorrect == index;

    return Row(
      children: [
        IconButton(
          icon: Icon(
            isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
            color: isSelected ? AppColors.secondary : AppColors.outline,
          ),
          onPressed: () => onSelect(index),
        ),
        Expanded(
          child: TextField(
            controller: ctrl,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              hintText: 'Choice ${index + 1}',
            ),
          ),
        ),
      ],
    );
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
          'Quiz Builder & Questions',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights_rounded, color: AppColors.primary),
            tooltip: 'Student Submissions',
            onPressed: () => context.push('/teacher/quizzes/1/results'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quiz Settings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _titleController,
                    label: 'Quiz Title',
                    hint: 'e.g. BLoC State Management Fundamentals',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _durationController,
                          label: 'Timer (Minutes)',
                          hint: '15',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.timer_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _passScoreController,
                          label: 'Pass Threshold (%)',
                          hint: '75',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.percent_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Questions List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questions (${_questions.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Question'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.roleTeacher),
                  onPressed: _showAddQuestionDialog,
                ),
              ],
            ),
            const SizedBox(height: 10),

            ..._questions.asMap().entries.map((entry) {
              final idx = entry.key;
              final q = entry.value;
              final choices = q['choices'] as List<dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${idx + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                            onPressed: () {
                              setState(() {
                                _questions.removeAt(idx);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        q['question'] as String,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...choices.map((c) {
                        final isCorrect = c['isCorrect'] as bool;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              Icon(
                                isCorrect ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                size: 16,
                                color: isCorrect ? AppColors.secondary : AppColors.outline,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  c['text'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                                    color: isCorrect ? AppColors.secondary : AppColors.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            CustomButton(
              text: 'Save & Publish Quiz',
              backgroundColor: AppColors.roleTeacher,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quiz and questions created successfully!'),
                    backgroundColor: AppColors.secondary,
                  ),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
