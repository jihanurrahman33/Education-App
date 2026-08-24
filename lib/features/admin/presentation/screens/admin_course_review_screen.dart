import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../../courses/presentation/bloc/course_bloc.dart';
import '../../../courses/presentation/bloc/course_event.dart';
import '../../../courses/presentation/bloc/course_state.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';

class AdminCourseReviewScreen extends StatefulWidget {
  final int courseId;

  const AdminCourseReviewScreen({super.key, required this.courseId});

  @override
  State<AdminCourseReviewScreen> createState() =>
      _AdminCourseReviewScreenState();
}

class _AdminCourseReviewScreenState extends State<AdminCourseReviewScreen> {
  @override
  void initState() {
    super.initState();
    _loadCourseDetails();
  }

  void _loadCourseDetails() {
    context
        .read<CourseBloc>()
        .add(FetchCourseDetailsRequested(widget.courseId));
  }

  void _onApprove(String courseTitle) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Approve Course Publication?',
      message:
          'Approving "$courseTitle" will publish it immediately to the public course catalog for all students.',
      confirmText: 'Approve & Publish',
      confirmColor: AppColors.secondary,
      icon: Icons.check_circle_rounded,
    );

    if (confirmed == true && mounted) {
      context.read<AdminBloc>().add(ApproveCourseEvent(widget.courseId));
    }
  }

  void _onReject(String courseTitle) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Reject Course Draft?',
      message:
          'Rejecting "$courseTitle" will notify the instructor to update and improve the course materials before resubmitting.',
      confirmText: 'Reject Draft',
      confirmColor: AppColors.error,
      icon: Icons.cancel_rounded,
    );

    if (confirmed == true && mounted) {
      context.read<AdminBloc>().add(RejectCourseEvent(widget.courseId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, adminState) {
        if (adminState.errorMessage != null) {
          AppToast.showError(context, adminState.errorMessage!);
        }
        if (adminState.successMessage != null) {
          AppToast.showSuccess(context, adminState.successMessage!);
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Course Quality Review',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon:
                  const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
              tooltip: 'Refresh',
              onPressed: _loadCourseDetails,
            ),
          ],
        ),
        body: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, courseState) {
            final isLoading = courseState.status.isLoading &&
                courseState.selectedCourse == null;
            final course = courseState.selectedCourse;

            if (isLoading) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 850),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: const [
                      LoadingSkeletonCard(height: 180, borderRadius: 16),
                      SizedBox(height: 20),
                      LoadingSkeletonCard(height: 100, borderRadius: 16),
                      SizedBox(height: 12),
                      LoadingSkeletonCard(height: 100, borderRadius: 16),
                    ],
                  ),
                ),
              );
            }

            if (courseState.status.isError && course == null) {
              return Center(
                child: ErrorView(
                  message: courseState.errorMessage ??
                      'Failed to load course details for review.',
                  onRetry: _loadCourseDetails,
                ),
              );
            }

            if (course == null) {
              return const Center(
                child: Text(
                  'Course details not available.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }

            final chapters = course.chapters;
            final totalLessons = course.lessonsCount;

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 768;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 850),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: isWide ? 32.0 : 20.0,
                              vertical: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Course Overview Card
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.12),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.3)),
                                            ),
                                            child: Text(
                                              course.status.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Course ID: #${course.id}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        course.title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        course.description,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person_outline_rounded,
                                            size: 16,
                                            color: AppColors.roleTeacher,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Instructor: ${course.teacherName ?? "Author"}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${chapters.length} Chapters • $totalLessons Lessons',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                const Text(
                                  'Submitted Curriculum & Lesson Verification',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                if (chapters.isEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: AppColors.border),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'No chapters or lessons uploaded yet for this course.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: chapters.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final chapter = chapters[index];
                                      return Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                              color: AppColors.border),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Chapter ${index + 1}: ${chapter.title}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            if (chapter.lessons.isEmpty)
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0),
                                                child: Text(
                                                  'No lessons added to this chapter.',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                              )
                                            else
                                              ...chapter.lessons.map(
                                                (lesson) => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        lesson.lessonType ==
                                                                'video'
                                                            ? Icons
                                                                .play_circle_outline_rounded
                                                            : (lesson.lessonType ==
                                                                    'pdf'
                                                                ? Icons
                                                                    .picture_as_pdf_outlined
                                                                : Icons
                                                                    .article_outlined),
                                                        size: 16,
                                                        color:
                                                            AppColors.secondary,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          '${lesson.title} (${lesson.durationMinutes > 0 ? "${lesson.durationMinutes} mins" : lesson.lessonType.toUpperCase()})',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color: AppColors
                                                                .textSecondary,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Sticky Action Bar
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isWide ? 32.0 : 20.0,
                            vertical: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            border: const Border(
                              top: BorderSide(color: AppColors.border),
                            ),
                          ),
                          child: BlocBuilder<AdminBloc, AdminState>(
                            builder: (context, adminState) {
                              final isActionLoading =
                                  adminState.status == AdminStatus.loading;

                              return Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      text: 'Reject Course Draft',
                                      icon: Icons.cancel_outlined,
                                      isOutlined: true,
                                      textColor: AppColors.error,
                                      backgroundColor: AppColors.error,
                                      isLoading: isActionLoading,
                                      onPressed: () => _onReject(course.title),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomButton(
                                      text: 'Approve & Publish',
                                      icon: Icons.check_circle_rounded,
                                      backgroundColor: AppColors.primary,
                                      textColor: AppColors.onPrimary,
                                      isLoading: isActionLoading,
                                      onPressed: () =>
                                          _onApprove(course.title),
                                    ),
                                  ),
                                ],
                              );
                            },
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
      ),
    );
  }
}
