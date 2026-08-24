import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../courses/domain/entities/course_entity.dart';
import '../../../courses/presentation/bloc/course_bloc.dart';
import '../../../courses/presentation/bloc/course_event.dart';
import '../../../courses/presentation/bloc/course_state.dart';
import '../../domain/entities/quiz_entity.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';

class TeacherQuizManagerScreen extends StatefulWidget {
  final int? quizId;
  final int? courseId;
  final int? chapterId;
  final int? lessonId;
  final bool isTab;

  const TeacherQuizManagerScreen({
    super.key,
    this.quizId,
    this.courseId,
    this.chapterId,
    this.lessonId,
    this.isTab = false,
  });

  @override
  State<TeacherQuizManagerScreen> createState() =>
      _TeacherQuizManagerScreenState();
}

class _TeacherQuizManagerScreenState extends State<TeacherQuizManagerScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController(text: '15');
  final _passScoreController = TextEditingController(text: '75');

  int? _selectedCourseId;
  int? _selectedChapterId;
  int? _selectedLessonId;

  bool _initializedSelections = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question':
          'Which layer in Clean Architecture defines the Repository Interface contracts?',
      'choices': [
        {'text': 'Data Layer', 'isCorrect': false},
        {'text': 'Domain Layer', 'isCorrect': true},
        {'text': 'Presentation Layer', 'isCorrect': false},
        {'text': 'Core Layer', 'isCorrect': false},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedCourseId = widget.courseId;
    _selectedChapterId = widget.chapterId;
    _selectedLessonId = widget.lessonId;

    context.read<CourseBloc>().add(const FetchTeacherCoursesRequested());
    if (_selectedCourseId != null) {
      context
          .read<CourseBloc>()
          .add(FetchCourseDetailsRequested(_selectedCourseId!));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _passScoreController.dispose();
    super.dispose();
  }

  void _syncInitialSelections(CourseState courseState) {
    if (_initializedSelections) return;

    final teacherCourses = courseState.teacherCourses;
    if (teacherCourses.isEmpty) return;

    if (_selectedCourseId == null) {
      _selectedCourseId = teacherCourses.first.id;
      context
          .read<CourseBloc>()
          .add(FetchCourseDetailsRequested(_selectedCourseId!));
    }

    final CourseEntity? activeCourse =
        courseState.selectedCourse?.id == _selectedCourseId
            ? courseState.selectedCourse
            : (teacherCourses.where((c) => c.id == _selectedCourseId).firstOrNull);

    final chapters = activeCourse?.chapters ?? courseState.curriculum;

    if (chapters.isNotEmpty) {
      ChapterEntity? matchedChapter;

      if (_selectedLessonId != null) {
        matchedChapter = chapters.where((c) {
          return c.lessons.any((l) => l.id == _selectedLessonId);
        }).firstOrNull;

        if (matchedChapter != null) {
          _selectedChapterId = matchedChapter.id;
        }
      }

      if (_selectedChapterId != null) {
        matchedChapter ??= chapters
            .where((c) => c.id == _selectedChapterId)
            .firstOrNull;
      }

      matchedChapter ??=
          chapters.where((c) => c.lessons.isNotEmpty).firstOrNull ??
              chapters.first;
      _selectedChapterId = matchedChapter.id;

      if (matchedChapter.lessons.isNotEmpty) {
        if (_selectedLessonId == null ||
            !matchedChapter.lessons.any((l) => l.id == _selectedLessonId)) {
          _selectedLessonId = matchedChapter.lessons.first.id;
        }
      } else {
        _selectedLessonId = null;
      }

      _initializedSelections = true;
    }
  }

  void _onCourseChanged(int? newCourseId) {
    if (newCourseId == null || newCourseId == _selectedCourseId) return;

    setState(() {
      _selectedCourseId = newCourseId;
      _selectedChapterId = null;
      _selectedLessonId = null;
      _initializedSelections = false;
    });

    context
        .read<CourseBloc>()
        .add(FetchCourseDetailsRequested(newCourseId));
  }

  void _onChapterChanged(int? newChapterId, List<ChapterEntity> chapters) {
    if (newChapterId == null || newChapterId == _selectedChapterId) return;

    final targetChapter =
        chapters.where((c) => c.id == newChapterId).firstOrNull;

    setState(() {
      _selectedChapterId = newChapterId;
      _selectedLessonId = targetChapter != null && targetChapter.lessons.isNotEmpty
          ? targetChapter.lessons.first.id
          : null;
    });
  }

  void _onLessonChanged(int? newLessonId) {
    if (newLessonId == null || newLessonId == _selectedLessonId) return;
    setState(() {
      _selectedLessonId = newLessonId;
    });
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
          backgroundColor: AppColors.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Add Question & Choices',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: qController,
                  label: 'Question Text',
                  hint: 'Enter question description...',
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Choices (Select correct answer):',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                _buildChoiceRow(0, c1, correctIndex,
                    (val) => setDialogState(() => correctIndex = val)),
                _buildChoiceRow(1, c2, correctIndex,
                    (val) => setDialogState(() => correctIndex = val)),
                _buildChoiceRow(2, c3, correctIndex,
                    (val) => setDialogState(() => correctIndex = val)),
                _buildChoiceRow(3, c4, correctIndex,
                    (val) => setDialogState(() => correctIndex = val)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.roleTeacher,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (qController.text.trim().isEmpty) {
                  AppToast.showError(context, 'Question description cannot be empty');
                  return;
                }
                if (c1.text.trim().isEmpty ||
                    c2.text.trim().isEmpty ||
                    c3.text.trim().isEmpty ||
                    c4.text.trim().isEmpty) {
                  AppToast.showError(context, 'All 4 choices must be provided');
                  return;
                }

                setState(() {
                  _questions.add({
                    'question': qController.text.trim(),
                    'choices': [
                      {'text': c1.text.trim(), 'isCorrect': correctIndex == 0},
                      {'text': c2.text.trim(), 'isCorrect': correctIndex == 1},
                      {'text': c3.text.trim(), 'isCorrect': correctIndex == 2},
                      {'text': c4.text.trim(), 'isCorrect': correctIndex == 3},
                    ],
                  });
                });
                Navigator.of(ctx).pop();
              },
              child: const Text(
                'Add Question',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceRow(
    int index,
    TextEditingController controller,
    int selectedIndex,
    ValueChanged<int> onSelect,
  ) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppColors.secondary : AppColors.textMuted,
            ),
            onPressed: () => onSelect(index),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                hintStyle: const TextStyle(color: AppColors.textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.roleTeacher),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSaveQuiz() {
    if (_selectedCourseId == null) {
      AppToast.showError(
          context, 'Please select one of your authored courses first.');
      return;
    }

    if (_selectedLessonId == null) {
      AppToast.showError(
        context,
        'Please select a specific lesson in your course curriculum to attach this quiz.',
      );
      return;
    }

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      AppToast.showError(context, 'Please provide a quiz title.');
      return;
    }

    if (_questions.isEmpty) {
      AppToast.showError(
          context, 'Please add at least one question to this assessment.');
      return;
    }

    final passScore = int.tryParse(_passScoreController.text.trim()) ?? 75;

    final questionInputs = _questions.asMap().entries.map((entry) {
      final idx = entry.key;
      final q = entry.value;
      final choicesRaw = q['choices'] as List<dynamic>;
      final choices = choicesRaw.map((c) {
        return ChoiceEntity(
          text: (c['text'] as String?)?.trim() ?? '',
          isCorrect: c['isCorrect'] as bool? ?? false,
        );
      }).toList();

      return CreateQuizQuestionInput(
        text: (q['question'] as String?)?.trim() ?? '',
        order: idx + 1,
        choices: choices,
      );
    }).toList();

    context.read<QuizBloc>().add(
          CreateQuizSubmitted(
            lessonId: _selectedLessonId!,
            title: title,
            description: _descriptionController.text.trim(),
            passScorePercent: passScore,
            questions: questionInputs,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    if (user != null &&
        user.role == UserRole.teacher &&
        !user.isApprovedTeacher) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text('Create Quiz',
              style: TextStyle(color: AppColors.textPrimary)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: EmptyStateWidget(
              icon: Icons.hourglass_top_rounded,
              title: 'Account Approval Required',
              message:
                  'Your instructor account is currently undergoing administrative review. Creating and managing quizzes is locked until an administrator approves your instructor registration.',
              actionText: 'Check Application Status',
              onAction: () => context.push('/teacher/pending'),
            ),
          ),
        ),
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              AppToast.showError(context, state.errorMessage!);
            }
            if (state.successMessage != null) {
              AppToast.showSuccess(context, state.successMessage!);
              if (!widget.isTab) {
                context.pop();
              }
            }
          },
        ),
        BlocListener<CourseBloc, CourseState>(
          listener: (context, courseState) {
            _syncInitialSelections(courseState);
          },
        ),
      ],
      child: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, quizState) {
          final isLoading = quizState.status.isLoading;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: widget.isTab
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: AppColors.textPrimary),
                      onPressed: () => context.pop(),
                    ),
              title: const Text(
                'Create Quiz',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            body: BlocBuilder<CourseBloc, CourseState>(
              builder: (context, courseState) {
                _syncInitialSelections(courseState);

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 768;

                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            isWide ? 32.0 : 20.0,
                            8.0,
                            isWide ? 32.0 : 20.0,
                            24.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 1. Create Quiz Hero Banner
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.roleTeacher,
                                      Color(0xFF5B21B6)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.roleTeacher
                                          .withValues(alpha: 0.25),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Create Quiz & Assessment',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            'Attach multiple-choice assessment questions directly to your course lessons.',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.quiz_rounded,
                                      size: 40,
                                      color: Colors.white70,
                                    ),
                                  ],
                                ),
                              ),

                              // 2. Course, Chapter & Lesson Assignment Card (Solves missing selection issue)
                              _buildCourseAndLessonSelectorCard(courseState),
                              const SizedBox(height: 16),

                              // 3. Quiz Configuration Card
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Quiz Details & Parameters',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      controller: _titleController,
                                      label: 'Quiz Title',
                                      hint:
                                          'e.g. Clean Architecture & BLoC Evaluation',
                                      prefixIcon: Icons.quiz_rounded,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      controller: _descriptionController,
                                      label: 'Description',
                                      hint:
                                          'Brief description of what is evaluated in this assessment...',
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                            controller: _durationController,
                                            label: 'Time Limit (Mins)',
                                            hint: '15',
                                            keyboardType:
                                                TextInputType.number,
                                            prefixIcon:
                                                Icons.timer_outlined,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: CustomTextField(
                                            controller: _passScoreController,
                                            label: 'Pass Threshold (%)',
                                            hint: '75',
                                            keyboardType:
                                                TextInputType.number,
                                            prefixIcon:
                                                Icons.percent_rounded,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // 4. Questions List Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Questions (${_questions.length})',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.add_rounded,
                                        size: 18),
                                    label: const Text('Add Question'),
                                    style: TextButton.styleFrom(
                                        foregroundColor:
                                            AppColors.roleTeacher),
                                    onPressed: _showAddQuestionDialog,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              if (_questions.isEmpty)
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: AppColors.border),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(Icons.quiz_outlined,
                                          size: 36,
                                          color: AppColors.textSecondary),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'No Questions Added Yet',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Tap "Add Question" above to insert multiple-choice questions.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ..._questions.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final q = entry.value;
                                  final choices =
                                      q['choices'] as List<dynamic>;

                                  return Card(
                                    margin:
                                        const EdgeInsets.only(bottom: 12),
                                    elevation: 0,
                                    color: AppColors.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16),
                                      side: const BorderSide(
                                          color: AppColors.border),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Text(
                                                'Question ${idx + 1}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons
                                                        .delete_outline_rounded,
                                                    size: 18,
                                                    color: AppColors.error),
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
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          ...choices.map((c) {
                                            final isCorrect =
                                                c['isCorrect'] as bool;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    isCorrect
                                                        ? Icons
                                                            .check_circle_rounded
                                                        : Icons
                                                            .radio_button_unchecked_rounded,
                                                    size: 16,
                                                    color: isCorrect
                                                        ? AppColors.secondary
                                                        : AppColors.textMuted,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      c['text'] as String,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: isCorrect
                                                            ? FontWeight.bold
                                                            : FontWeight
                                                                .normal,
                                                        color: isCorrect
                                                            ? AppColors
                                                                .secondary
                                                            : AppColors
                                                                .textSecondary,
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
                                text: 'Create Quiz',
                                icon: Icons.add_task_rounded,
                                backgroundColor: AppColors.roleTeacher,
                                isLoading: isLoading,
                                onPressed: _onSaveQuiz,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseAndLessonSelectorCard(CourseState courseState) {
    final teacherCourses = courseState.teacherCourses;
    final isTeacherCoursesLoading =
        courseState.status.isLoading && teacherCourses.isEmpty;

    final CourseEntity? selectedCourse = _selectedCourseId != null
        ? (courseState.selectedCourse?.id == _selectedCourseId
            ? courseState.selectedCourse
            : (teacherCourses
                .where((c) => c.id == _selectedCourseId)
                .firstOrNull))
        : null;

    final chapters = selectedCourse?.chapters ?? courseState.curriculum;
    final ChapterEntity? selectedChapter = _selectedChapterId != null
        ? chapters.where((c) => c.id == _selectedChapterId).firstOrNull
        : null;

    final lessons = selectedChapter?.lessons ?? [];
    final LessonEntity? selectedLesson = _selectedLessonId != null
        ? lessons.where((l) => l.id == _selectedLessonId).firstOrNull
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.link_rounded,
                  color: AppColors.roleTeacher, size: 20),
              SizedBox(width: 8),
              Text(
                'Attach to Lesson (Required)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Quizzes in EduFlow belong to specific course lessons that you authored.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          if (isTeacherCoursesLoading) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.roleTeacher),
                ),
              ),
            ),
          ] else if (teacherCourses.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: AppColors.warning, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'No Authored Courses Found',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'You need to create a course with at least one chapter and lesson before creating a quiz.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Create Course Now'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.roleTeacher,
                      side: const BorderSide(color: AppColors.roleTeacher),
                    ),
                    onPressed: () => context.push('/teacher/courses/create'),
                  ),
                ],
              ),
            ),
          ] else ...[
            // 1. Select Course Dropdown
            DropdownButtonFormField<int>(
              key: ValueKey('course_$_selectedCourseId'),
              initialValue: teacherCourses.any((c) => c.id == _selectedCourseId)
                  ? _selectedCourseId
                  : null,
              decoration: InputDecoration(
                labelText: 'Select Course',
                prefixIcon: const Icon(Icons.school_rounded,
                    color: AppColors.roleTeacher),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
              items: teacherCourses.map((c) {
                return DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(
                    c.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: _onCourseChanged,
            ),
            const SizedBox(height: 12),

            if (_selectedCourseId != null) ...[
              if (courseState.status.isLoading &&
                  courseState.selectedCourse?.id != _selectedCourseId) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Loading curriculum chapters...',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ] else if (chapters.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'This course has no chapters yet.',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(
                            '/teacher/courses/$_selectedCourseId/curriculum'),
                        child: const Text('Add Chapter',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // 2. Select Chapter Dropdown
                DropdownButtonFormField<int>(
                  key: ValueKey('chapter_$_selectedChapterId'),
                  initialValue: chapters.any((c) => c.id == _selectedChapterId)
                      ? _selectedChapterId
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Select Chapter / Module',
                    prefixIcon: const Icon(Icons.folder_open_rounded,
                        color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                  items: chapters.map((ch) {
                    return DropdownMenuItem<int>(
                      value: ch.id,
                      child: Text(
                        'Chapter ${ch.order}: ${ch.title} (${ch.lessons.length} lessons)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => _onChapterChanged(val, chapters),
                ),
                const SizedBox(height: 12),

                // 3. Select Lesson Dropdown
                if (_selectedChapterId != null) ...[
                  if (lessons.isEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'This chapter has no lessons yet.',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary),
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push(
                              '/teacher/courses/$_selectedCourseId/chapters/$_selectedChapterId/lessons/create',
                            ),
                            child: const Text('Add Lesson',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    DropdownButtonFormField<int>(
                      key: ValueKey('lesson_$_selectedLessonId'),
                      initialValue: lessons.any((l) => l.id == _selectedLessonId)
                          ? _selectedLessonId
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Select Target Lesson',
                        prefixIcon: const Icon(Icons.play_lesson_rounded,
                            color: AppColors.secondary),
                        filled: true,
                        fillColor: AppColors.surfaceContainerLow,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                      ),
                      items: lessons.map((l) {
                        return DropdownMenuItem<int>(
                          value: l.id,
                          child: Text(
                            '${l.title} (${l.lessonType.toUpperCase()})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: _onLessonChanged,
                    ),
                  ],
                ],
              ],
            ],

            // Breadcrumb selection banner
            if (selectedCourse != null &&
                selectedChapter != null &&
                selectedLesson != null) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.secondary, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Target: ${selectedCourse.title} > ${selectedChapter.title} > ${selectedLesson.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
