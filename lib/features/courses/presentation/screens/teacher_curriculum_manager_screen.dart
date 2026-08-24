import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/course_entity.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';

class TeacherCurriculumManagerScreen extends StatefulWidget {
  final int courseId;

  const TeacherCurriculumManagerScreen({super.key, required this.courseId});

  @override
  State<TeacherCurriculumManagerScreen> createState() =>
      _TeacherCurriculumManagerScreenState();
}

class _TeacherCurriculumManagerScreenState
    extends State<TeacherCurriculumManagerScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<CourseBloc>().add(FetchCourseDetailsRequested(widget.courseId));
  }

  void _showAddChapterDialog(int chaptersCount) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add New Chapter', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: 'e.g. Chapter 1: Introduction to Framework',
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
              final text = titleController.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(ctx).pop();
                context.read<CourseBloc>().add(
                      CreateChapterRequested(
                        courseId: widget.courseId,
                        title: text,
                        order: chaptersCount + 1,
                      ),
                    );
              }
            },
            child: const Text('Add Chapter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditChapterDialog(ChapterEntity chapter) {
    final titleController = TextEditingController(text: chapter.title);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Chapter', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Chapter Title',
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
              final text = titleController.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(ctx).pop();
                context.read<CourseBloc>().add(
                      UpdateChapterRequested(
                        chapterId: chapter.id,
                        courseId: widget.courseId,
                        title: text,
                        order: chapter.order,
                      ),
                    );
              }
            },
            child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteChapter(ChapterEntity chapter) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Chapter',
      message:
          'Are you sure you want to delete "${chapter.title}"? All associated lessons will also be removed.',
      confirmText: 'Delete Chapter',
      confirmColor: AppColors.error,
      icon: Icons.delete_forever_rounded,
    );

    if (confirmed == true && mounted) {
      context.read<CourseBloc>().add(
            DeleteChapterRequested(
              chapterId: chapter.id,
              courseId: widget.courseId,
            ),
          );
    }
  }

  Future<void> _deleteLesson(LessonEntity lesson) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Lesson',
      message: 'Are you sure you want to delete lesson "${lesson.title}"?',
      confirmText: 'Delete Lesson',
      confirmColor: AppColors.error,
      icon: Icons.delete_outline_rounded,
    );

    if (confirmed == true && mounted) {
      context.read<CourseBloc>().add(
            DeleteLessonRequested(
              lessonId: lesson.id,
              courseId: widget.courseId,
            ),
          );
    }
  }

  void _togglePublish(bool isPublished) async {
    final nextState = !isPublished;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: nextState ? 'Publish Course?' : 'Unpublish Course?',
      message: nextState
          ? 'Once submitted, your course will be sent to administrators for final approval before going live to students.'
          : 'Unpublishing will hide this course from student discovery.',
      confirmText: nextState ? 'Submit for Approval' : 'Unpublish',
    );

    if (confirmed == true && mounted) {
      context
          .read<CourseBloc>()
          .add(TogglePublishCourseRequested(widget.courseId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    if (user != null && user.role == UserRole.teacher && !user.isApprovedTeacher) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text('Curriculum Manager',
              style: TextStyle(color: AppColors.textPrimary)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: EmptyStateWidget(
              icon: Icons.hourglass_top_rounded,
              title: 'Account Approval Required',
              message:
                  'Your instructor account is currently undergoing administrative review. Managing curriculum and lessons is locked until an administrator approves your instructor registration.',
              actionText: 'Check Application Status',
              onAction: () => context.push('/teacher/pending'),
            ),
          ),
        ),
      );
    }

    return BlocConsumer<CourseBloc, CourseState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error),
          );
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.secondary,
            ),
          );
        }
      },
      builder: (context, state) {
        final chapters = state.curriculum;
        final isPublished = state.selectedCourse?.isPublished ?? false;
        final isLoading = state.status.isLoading && chapters.isEmpty;

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
              'Curriculum & Syllabus',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
                tooltip: 'Refresh Curriculum',
                onPressed: _loadData,
              ),
              TextButton.icon(
                icon: Icon(
                  isPublished ? Icons.check_circle_rounded : Icons.publish_rounded,
                  size: 16,
                  color: isPublished ? AppColors.secondary : AppColors.roleTeacher,
                ),
                label: Text(
                  isPublished ? 'Submitted' : 'Publish',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isPublished ? AppColors.secondary : AppColors.roleTeacher,
                  ),
                ),
                onPressed: () => _togglePublish(isPublished),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => _loadData(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 768;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 32.0 : 20.0,
                        vertical: 20.0,
                      ),
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
                                style: TextButton.styleFrom(
                                    foregroundColor: AppColors.roleTeacher),
                                onPressed: () =>
                                    _showAddChapterDialog(chapters.length),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (isLoading)
                            const LoadingSkeletonCard(height: 140, borderRadius: 14)
                          else if (chapters.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(32.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.folder_open_rounded,
                                      size: 44, color: AppColors.textSecondary),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'No chapters created for this course yet.',
                                    style: TextStyle(
                                        fontSize: 14, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 14),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.add_rounded),
                                    label: const Text('Create First Chapter'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.roleTeacher,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () =>
                                        _showAddChapterDialog(chapters.length),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...chapters.map((chapter) {
                              final chapterId = chapter.id;
                              final lessons = chapter.lessons;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                elevation: 0,
                                color: AppColors.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              chapter.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined,
                                                size: 18,
                                                color: AppColors.textSecondary),
                                            tooltip: 'Edit Chapter',
                                            onPressed: () =>
                                                _showEditChapterDialog(chapter),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline_rounded,
                                                size: 18,
                                                color: AppColors.error),
                                            tooltip: 'Delete Chapter',
                                            onPressed: () =>
                                                _deleteChapter(chapter),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.add_circle_outline_rounded,
                                                color: AppColors.roleTeacher,
                                                size: 20),
                                            tooltip: 'Add Lesson to Chapter',
                                            onPressed: () async {
                                              await context.push(
                                                '/teacher/courses/${widget.courseId}/chapters/$chapterId/lessons/create',
                                              );
                                              _loadData();
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
                                            'No lessons in this chapter yet. Tap "+" to add lessons.',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textSecondary),
                                          ),
                                        )
                                      else
                                        ...lessons.map((lesson) {
                                          final isVideo = lesson.lessonType == 'video';
                                          return Container(
                                            margin: const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: AppColors.surfaceContainerLow,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isVideo
                                                      ? Icons.videocam_rounded
                                                      : Icons.picture_as_pdf_rounded,
                                                  size: 18,
                                                  color: isVideo
                                                      ? AppColors.primary
                                                      : AppColors.error,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    lesson.title,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.textPrimary,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.delete_outline_rounded,
                                                      size: 16,
                                                      color: AppColors.error),
                                                  tooltip: 'Delete Lesson',
                                                  onPressed: () =>
                                                      _deleteLesson(lesson),
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
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
