import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_view.dart';
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
    context
        .read<CourseBloc>()
        .add(FetchCourseDetailsRequested(widget.courseId));
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/dashboard');
    }
  }

  void _showAddChapterDialog(int chaptersCount) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Add New Chapter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: titleController,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary),
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
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.roleTeacher),
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
            child:
                const Text('Add Chapter', style: TextStyle(color: Colors.white)),
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
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Edit Chapter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: titleController,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary),
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
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.roleTeacher),
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
            child: const Text('Save Changes',
                style: TextStyle(color: Colors.white)),
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
      title: nextState ? 'Submit Course for Publication?' : 'Unpublish Course?',
      message: nextState
          ? 'Once submitted, your course curriculum and lessons will be reviewed by administrators before going live in the student catalog.'
          : 'Unpublishing will revert this course back to draft status and remove it from student discovery.',
      confirmText: nextState ? 'Submit for Approval' : 'Revert to Draft',
      confirmColor: nextState ? AppColors.secondary : AppColors.error,
      icon: nextState ? Icons.publish_rounded : Icons.unpublished_rounded,
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
    if (user != null &&
        user.role == UserRole.teacher &&
        !user.isApprovedTeacher) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
            onPressed: _handleBack,
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
          AppToast.showError(context, state.errorMessage!);
        }
        if (state.successMessage != null) {
          AppToast.showSuccess(context, state.successMessage!);
        }
      },
      builder: (context, state) {
        final course = state.selectedCourse;
        final chapters = state.curriculum;
        final isPublished = course?.isPublished ?? false;
        final isLoading = state.status.isLoading && course == null;

        if (state.status.isError && course == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.textPrimary),
                onPressed: _handleBack,
              ),
              title: const Text('Curriculum Manager',
                  style: TextStyle(color: AppColors.textPrimary)),
            ),
            body: Center(
              child: ErrorView(
                message: state.errorMessage ??
                    'Failed to load course curriculum. Please try again.',
                onRetry: _loadData,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: AppColors.textPrimary),
              onPressed: _handleBack,
            ),
            title: Text(
              course != null ? course.title : 'Curriculum & Syllabus',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded,
                    color: AppColors.textPrimary),
                tooltip: 'Refresh Curriculum',
                onPressed: _loadData,
              ),
              IconButton(
                icon: const Icon(Icons.edit_note_rounded,
                    color: AppColors.roleTeacher),
                tooltip: 'Edit Course Details',
                onPressed: () =>
                    context.push('/teacher/courses/${widget.courseId}/edit'),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => _loadData(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 768;

                if (isLoading) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            LoadingSkeletonCard(height: 160, borderRadius: 16),
                            SizedBox(height: 16),
                            LoadingSkeletonCard(height: 120, borderRadius: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        isWide ? 32.0 : 20.0,
                        8.0,
                        isWide ? 32.0 : 20.0,
                        24.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Course Status & Overview Hero Card
                          _buildCourseStatusHero(course, isPublished),
                          const SizedBox(height: 24),

                          // 2. Chapters Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Curriculum Chapters',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${chapters.length}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
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

                          // 3. Chapters & Lessons Content
                          if (chapters.isEmpty)
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
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.roleTeacher
                                          .withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.menu_book_rounded,
                                      size: 40,
                                      color: AppColors.roleTeacher,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No Chapters Added Yet',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Organize your course by adding modules and chapters with video or PDF lessons.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.add_rounded),
                                    label: const Text('Create First Chapter'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.roleTeacher,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () =>
                                        _showAddChapterDialog(chapters.length),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...chapters.asMap().entries.map((entry) {
                              final index = entry.key;
                              final chapter = entry.value;
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: AppColors.primary
                                                .withValues(alpha: 0.15),
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
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
                                            icon: const Icon(
                                                Icons.edit_outlined,
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
                                                Icons
                                                    .add_circle_outline_rounded,
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
                                          padding: const EdgeInsets.all(14),
                                          margin:
                                              const EdgeInsets.only(top: 6),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceContainerLow,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                  Icons.info_outline_rounded,
                                                  size: 16,
                                                  color:
                                                      AppColors.textSecondary),
                                              const SizedBox(width: 8),
                                              const Text(
                                                'No lessons in this chapter yet. Tap "+" above.',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors
                                                        .textSecondary),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        ...lessons.map((lesson) {
                                          final isVideo =
                                              lesson.lessonType == 'video';
                                          return Container(
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: AppColors
                                                  .surfaceContainerLow,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isVideo
                                                      ? Icons.videocam_rounded
                                                      : Icons
                                                          .picture_as_pdf_rounded,
                                                  size: 18,
                                                  color: isVideo
                                                      ? AppColors.primary
                                                      : AppColors.error,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        lesson.title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .textPrimary,
                                                        ),
                                                      ),
                                                      if (lesson
                                                              .durationMinutes >
                                                          0)
                                                        Text(
                                                          '${lesson.durationMinutes} mins • ${lesson.lessonType.toUpperCase()}',
                                                          style: const TextStyle(
                                                            fontSize: 11,
                                                            color: AppColors
                                                                .textSecondary,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons
                                                          .delete_outline_rounded,
                                                      size: 18,
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
                          const SizedBox(height: 24),

                          // 4. Publication Submission Card
                          _buildPublishActionCard(isPublished, chapters.length),
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

  Widget _buildCourseStatusHero(CourseEntity? course, bool isPublished) {
    final title = course?.title ?? 'Untitled Course';
    final category = course?.category ?? 'General Education';
    final price = course?.price ?? 0.0;
    final status = course?.status ?? 'draft';

    Color statusColor;
    String statusLabel;

    if (isPublished) {
      if (status == 'approved') {
        statusColor = AppColors.secondary;
        statusLabel = 'APPROVED & LIVE';
      } else if (status == 'rejected') {
        statusColor = AppColors.error;
        statusLabel = 'REJECTED BY ADMIN';
      } else {
        statusColor = AppColors.roleTeacher;
        statusLabel = 'SUBMITTED FOR MODERATION';
      }
    } else {
      statusColor = AppColors.textMuted;
      statusLabel = 'DRAFT (UNPUBLISHED)';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: statusColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                price == 0 ? 'Free Access' : '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Category: $category',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          if (!isPublished) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.tips_and_updates_rounded,
                      size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Next Step: Add your curriculum chapters & lessons below, then submit for administrative publication approval.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPublishActionCard(bool isPublished, int totalChapters) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPublished
                    ? Icons.verified_rounded
                    : Icons.rocket_launch_rounded,
                color:
                    isPublished ? AppColors.secondary : AppColors.roleTeacher,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                isPublished
                    ? 'Publication Status'
                    : 'Ready to Publish Course?',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isPublished
                ? 'Your course has been submitted. Any further chapter edits will be reflected in real-time.'
                : 'Submitting will send your course to administrators for approval before it becomes visible to students.',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: isPublished
                      ? 'Revert to Draft'
                      : 'Submit for Publication Approval',
                  icon: isPublished
                      ? Icons.unpublished_rounded
                      : Icons.publish_rounded,
                  backgroundColor:
                      isPublished ? AppColors.error : AppColors.roleTeacher,
                  textColor: Colors.white,
                  onPressed: () => _togglePublish(isPublished),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Add Assessment Quiz',
            icon: Icons.quiz_outlined,
            isOutlined: true,
            backgroundColor: AppColors.roleTeacher,
            textColor: AppColors.roleTeacher,
            onPressed: () => context.push('/teacher/quizzes/create'),
          ),
        ],
      ),
    );
  }
}
