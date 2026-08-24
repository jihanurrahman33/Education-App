import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/create_chapter_usecase.dart';
import '../../domain/usecases/delete_chapter_usecase.dart';
import '../../domain/usecases/get_chapters_usecase.dart';
import '../../domain/usecases/get_course_details_usecase.dart';
import '../../domain/usecases/patch_chapter_usecase.dart';
import '../../domain/usecases/toggle_publish_course_usecase.dart';

class TeacherCurriculumManagerScreen extends StatefulWidget {
  final int courseId;

  const TeacherCurriculumManagerScreen({super.key, required this.courseId});

  @override
  State<TeacherCurriculumManagerScreen> createState() =>
      _TeacherCurriculumManagerScreenState();
}

class _TeacherCurriculumManagerScreenState
    extends State<TeacherCurriculumManagerScreen> {
  final GetChaptersUseCase _getChaptersUseCase = GetIt.I<GetChaptersUseCase>();
  final CreateChapterUseCase _createChapterUseCase = GetIt.I<CreateChapterUseCase>();
  final PatchChapterUseCase _patchChapterUseCase = GetIt.I<PatchChapterUseCase>();
  final DeleteChapterUseCase _deleteChapterUseCase = GetIt.I<DeleteChapterUseCase>();
  final GetCourseDetailsUseCase _getCourseDetailsUseCase = GetIt.I<GetCourseDetailsUseCase>();
  final TogglePublishCourseUseCase _togglePublishCourseUseCase = GetIt.I<TogglePublishCourseUseCase>();

  List<ChapterEntity> _chapters = [];
  bool _isLoading = true;
  bool _isPublished = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final results = await Future.wait([
      _getChaptersUseCase(GetChaptersParams(courseId: widget.courseId)),
      _getCourseDetailsUseCase(GetCourseDetailsParams(courseId: widget.courseId)),
    ]);

    if (!mounted) return;

    final chapResult = results[0];
    final courseResult = results[1];

    chapResult.fold(
      (failure) => null,
      (chapters) => _chapters = chapters as List<ChapterEntity>,
    );

    courseResult.fold(
      (failure) => null,
      (course) => _isPublished = (course as CourseEntity).isPublished,
    );

    setState(() => _isLoading = false);
  }

  Future<void> _loadChapters() async {
    await _loadData();
  }

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
            onPressed: () async {
              final text = titleController.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(ctx).pop();
                final result = await _createChapterUseCase(CreateChapterParams(
                  courseId: widget.courseId,
                  title: text,
                  order: _chapters.length + 1,
                ));

                if (!mounted) return;

                result.fold(
                  (failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create chapter: ${failure.message}'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  },
                  (created) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Chapter "${created.title}" created successfully!'),
                        backgroundColor: AppColors.secondary,
                      ),
                    );
                    _loadChapters();
                  },
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
            onPressed: () async {
              final text = titleController.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(ctx).pop();
                final result = await _patchChapterUseCase(PatchChapterParams(
                  id: chapter.id,
                  title: text,
                ));

                if (!mounted) return;

                result.fold(
                  (failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update chapter: ${failure.message}'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  },
                  (updated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Chapter updated to "${updated.title}"!'),
                        backgroundColor: AppColors.secondary,
                      ),
                    );
                    _loadChapters();
                  },
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
      message: 'Are you sure you want to delete "${chapter.title}"? All associated lessons will also be removed.',
      confirmText: 'Delete Chapter',
      confirmColor: AppColors.error,
      icon: Icons.delete_forever_rounded,
    );

    if (confirmed == true && mounted) {
      final result = await _deleteChapterUseCase(chapter.id);

      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete chapter: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (_) {
          setState(() {
            _chapters.removeWhere((c) => c.id == chapter.id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Chapter "${chapter.title}" deleted.'),
              backgroundColor: AppColors.secondary,
            ),
          );
        },
      );
    }
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
      final result = await _togglePublishCourseUseCase(widget.courseId);

      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update publish status: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (course) {
          setState(() {
            _isPublished = course.isPublished;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(course.isPublished
                  ? 'Course published / submitted for approval!'
                  : 'Course unpublished.'),
              backgroundColor: AppColors.secondary,
            ),
          );
        },
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
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
            tooltip: 'Refresh Curriculum',
            onPressed: _loadChapters,
          ),
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
      body: RefreshIndicator(
        onRefresh: _loadChapters,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

              if (_isLoading)
                const LoadingSkeletonCard(height: 140, borderRadius: 14)
              else if (_chapters.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.folder_open_rounded, size: 44, color: AppColors.textSecondary),
                      const SizedBox(height: 10),
                      const Text(
                        'No chapters created for this course yet.',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Create First Chapter'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.roleTeacher,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _showAddChapterDialog,
                      ),
                    ],
                  ),
                )
              else
                ..._chapters.map((chapter) {
                  final chapterId = chapter.id;
                  final lessons = chapter.lessons;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.4),
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
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                                tooltip: 'Edit Chapter',
                                onPressed: () => _showEditChapterDialog(chapter),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                                tooltip: 'Delete Chapter',
                                onPressed: () => _deleteChapter(chapter),
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
                                'No lessons in this chapter yet. Tap "+" to add lessons.',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            )
                          else
                            ...lessons.map((lesson) {
                              final isVideo = lesson.lessonType == 'video';
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
                                        lesson.title,
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
      ),
    );
  }
}
