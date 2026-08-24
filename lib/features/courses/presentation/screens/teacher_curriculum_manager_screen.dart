import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_button.dart';

class TeacherCurriculumManagerScreen extends StatefulWidget {
  final int courseId;

  const TeacherCurriculumManagerScreen({super.key, required this.courseId});

  @override
  State<TeacherCurriculumManagerScreen> createState() =>
      _TeacherCurriculumManagerScreenState();
}

class _TeacherCurriculumManagerScreenState
    extends State<TeacherCurriculumManagerScreen> {
  bool _isPublished = false;

  final List<Map<String, dynamic>> _chapters = [
    {
      'id': 1,
      'title': 'Chapter 1: Foundations & Architecture Setup',
      'lessons': [
        {'id': 1, 'title': 'Introduction to Clean Architecture', 'type': 'video'},
        {'id': 2, 'title': 'Domain Invariants & Specifications', 'type': 'pdf'},
      ],
    },
    {
      'id': 2,
      'title': 'Chapter 2: State Management & BLoC Streams',
      'lessons': [
        {'id': 3, 'title': 'BLoC State Machine Implementation', 'type': 'video'},
        {'id': 4, 'title': 'Error Boundaries and UI Emits', 'type': 'video'},
      ],
    },
  ];

  void _showAddChapterDialog() {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add New Chapter', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: 'e.g. Chapter 3: Advanced Network Layer',
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
              if (titleController.text.trim().isNotEmpty) {
                setState(() {
                  _chapters.add({
                    'id': _chapters.length + 1,
                    'title': titleController.text.trim(),
                    'lessons': [],
                  });
                });
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add Chapter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _togglePublish() async {
    final nextState = !_isPublished;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: nextState ? 'Publish Course?' : 'Unpublish Course?',
      message: nextState
          ? 'Once submitted, your course will be sent to administrators for final approval before going live to students.'
          : 'Unpublishing will hide this course from student discovery.',
      confirmText: nextState ? 'Submit for Approval' : 'Unpublish',
    );

    if (confirmed == true && mounted) {
      setState(() {
        _isPublished = nextState;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(nextState
              ? 'Course submitted for admin approval!'
              : 'Course has been unpublished.'),
          backgroundColor: AppColors.secondary,
        ),
      );
    }
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
          'Curriculum & Syllabus',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton.icon(
            icon: Icon(
              _isPublished ? Icons.check_circle_rounded : Icons.publish_rounded,
              size: 16,
              color: _isPublished ? AppColors.secondary : AppColors.roleTeacher,
            ),
            label: Text(
              _isPublished ? 'Submitted' : 'Publish',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isPublished ? AppColors.secondary : AppColors.roleTeacher,
              ),
            ),
            onPressed: _togglePublish,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Course Chapters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Chapter'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.roleTeacher),
                  onPressed: _showAddChapterDialog,
                ),
              ],
            ),
            const SizedBox(height: 12),

            ..._chapters.map((chapter) {
              final chapterId = chapter['id'] as int;
              final lessons = chapter['lessons'] as List<dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chapter['title'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded,
                                color: AppColors.roleTeacher, size: 20),
                            tooltip: 'Add Lesson to Chapter',
                            onPressed: () {
                              context.push(
                                '/teacher/courses/${widget.courseId}/chapters/$chapterId/lessons/create',
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (lessons.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.center,
                          child: const Text(
                            'No lessons in this chapter yet. Tap "+" to upload video or PDF.',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        )
                      else
                        ...lessons.map((lesson) {
                          final isVideo = lesson['type'] == 'video';
                          return Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isVideo ? Icons.videocam_rounded : Icons.picture_as_pdf_rounded,
                                  size: 18,
                                  color: isVideo ? AppColors.primary : AppColors.error,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    lesson['title'] as String,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 16),
                                  onPressed: () {},
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
            const SizedBox(height: 20),

            CustomButton(
              text: 'Add Quiz to Course',
              icon: Icons.quiz_outlined,
              isOutlined: true,
              backgroundColor: AppColors.roleTeacher,
              textColor: AppColors.roleTeacher,
              onPressed: () => context.push('/teacher/quizzes/create'),
            ),
          ],
        ),
      ),
    );
  }
}
