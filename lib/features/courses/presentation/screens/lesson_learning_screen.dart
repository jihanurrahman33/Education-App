import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../../progress/presentation/bloc/progress_event.dart';
import '../../../progress/presentation/bloc/progress_state.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/get_course_details_usecase.dart';
import '../../domain/usecases/get_lesson_by_id_usecase.dart';
import '../widgets/lesson_pdf_viewer_widget.dart';
import '../widgets/lesson_video_player_widget.dart';

class LessonLearningScreen extends StatefulWidget {
  final int courseId;
  final int lessonId;

  const LessonLearningScreen({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  @override
  State<LessonLearningScreen> createState() => _LessonLearningScreenState();
}

class _LessonLearningScreenState extends State<LessonLearningScreen> {
  final GetLessonByIdUseCase _getLessonByIdUseCase =
      GetIt.I<GetLessonByIdUseCase>();
  final GetCourseDetailsUseCase _getCourseDetailsUseCase =
      GetIt.I<GetCourseDetailsUseCase>();

  LessonEntity? _lesson;
  CourseEntity? _course;
  LessonEntity? _nextLesson;
  LessonEntity? _prevLesson;
  int _lessonIndexInCourse = 0;
  int _totalLessonsInCourse = 1;
  String? _chapterTitle;

  bool _isLoading = true;
  bool _isPlaying = true;
  double _videoProgress = 0.0;
  bool _isCompleted = false;
  bool _showingNotes = false;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    setState(() => _isLoading = true);

    // Cross-reference progress state for lesson completion status
    final progressState = context.read<ProgressBloc>().state;
    final bool alreadyCompleted = progressState.completedLessons
        .any((cl) => cl.lesson == widget.lessonId);

    final results = await Future.wait([
      _getLessonByIdUseCase(widget.lessonId),
      _getCourseDetailsUseCase(
          GetCourseDetailsParams(courseId: widget.courseId)),
    ]);

    if (!mounted) return;

    final lessonRes = results[0];
    final courseRes = results[1];

    LessonEntity? loadedLesson;
    lessonRes.fold(
      (failure) => null,
      (lesson) => loadedLesson = lesson as LessonEntity,
    );

    CourseEntity? loadedCourse;
    courseRes.fold(
      (failure) => null,
      (course) => loadedCourse = course as CourseEntity,
    );

    LessonEntity? next;
    LessonEntity? prev;
    int currentIdx = 0;
    int total = 1;
    String? chapterName;

    if (loadedCourse != null) {
      final allLessons = <LessonEntity>[];
      for (final ch in loadedCourse!.chapters) {
        for (final l in ch.lessons) {
          allLessons.add(l);
          if (l.id == widget.lessonId) {
            chapterName = ch.title;
          }
        }
      }
      total = allLessons.isEmpty ? 1 : allLessons.length;
      final foundIdx = allLessons.indexWhere((l) => l.id == widget.lessonId);
      if (foundIdx != -1) {
        currentIdx = foundIdx;
        if (foundIdx + 1 < allLessons.length) {
          next = allLessons[foundIdx + 1];
        }
        if (foundIdx > 0) {
          prev = allLessons[foundIdx - 1];
        }
      }
    }

    setState(() {
      _lesson = loadedLesson;
      _course = loadedCourse;
      _nextLesson = next;
      _prevLesson = prev;
      _lessonIndexInCourse = currentIdx;
      _totalLessonsInCourse = total;
      _chapterTitle = chapterName;
      _isCompleted = alreadyCompleted;
      _showingNotes = loadedLesson?.lessonType == 'pdf';
      _isLoading = false;
    });
  }

  void _onMarkCompleted() {
    context.read<ProgressBloc>().add(
          CompleteLessonProgressEvent(
            lessonId: widget.lessonId,
            courseId: widget.courseId,
          ),
        );
    setState(() {
      _isCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessonTitle = _lesson?.title ?? 'Lesson ${widget.lessonId}';
    final isPdf = _lesson?.lessonType == 'pdf' || _showingNotes;
    final textContent = _lesson?.textContent ?? '';

    return BlocListener<ProgressBloc, ProgressState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          AppToast.showSuccess(context, state.successMessage!);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceDark,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceDark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lessonTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_chapterTitle != null || _course?.title != null)
                Text(
                  _chapterTitle != null
                      ? (_course?.title != null
                          ? '$_chapterTitle • ${_course!.title}'
                          : _chapterTitle!)
                      : (_course?.title ?? ''),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                _showingNotes
                    ? Icons.videocam_rounded
                    : Icons.description_rounded,
                color: Colors.white,
              ),
              tooltip: _showingNotes ? 'Switch to Video' : 'View Notes & PDF',
              onPressed: () {
                setState(() {
                  _showingNotes = !_showingNotes;
                });
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        children: [
                          // Reusable Media Player / PDF Viewer Container
                          if (!isPdf)
                            LessonVideoPlayerWidget(
                              isPlaying: _isPlaying,
                              videoProgress: _videoProgress,
                              onTogglePlay: () {
                                setState(() => _isPlaying = !_isPlaying);
                              },
                              onSeek: (val) {
                                setState(() => _videoProgress = val);
                              },
                            )
                          else
                            LessonPdfViewerWidget(
                              onOpenPdf: () {
                                AppToast.showInfo(
                                    context, 'Opening PDF reader viewer...');
                              },
                            ),

                          // Content & Navigation Container
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Lesson ${_lessonIndexInCourse + 1} of $_totalLessonsInCourse',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      if (_isCompleted)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary
                                                .withValues(alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.check_circle_rounded,
                                                  size: 14,
                                                  color: AppColors.secondary),
                                              SizedBox(width: 4),
                                              Text(
                                                'Completed',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.secondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    lessonTitle,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (textContent.isNotEmpty)
                                    Text(
                                      textContent,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                        height: 1.4,
                                      ),
                                    )
                                  else
                                    const Text(
                                      'Watch the lecture or review the study materials carefully to complete this lesson.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                  const Spacer(),

                                  // Bottom Action Bar
                                  Row(
                                    children: [
                                      // Previous Lesson Button
                                      if (_prevLesson != null) ...[
                                        IconButton.filled(
                                          style: IconButton.styleFrom(
                                            backgroundColor: AppColors
                                                .surfaceContainerHigh,
                                            foregroundColor:
                                                AppColors.textPrimary,
                                          ),
                                          icon: const Icon(
                                              Icons.arrow_back_rounded),
                                          tooltip:
                                              'Previous: ${_prevLesson!.title}',
                                          onPressed: () {
                                            context.pushReplacement(
                                              '/learning/${widget.courseId}/lesson/${_prevLesson!.id}',
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                      ],

                                      // Mark Completed Button
                                      Expanded(
                                        child: CustomButton(
                                          text: _isCompleted
                                              ? 'Lesson Completed'
                                              : 'Mark Complete',
                                          icon: _isCompleted
                                              ? Icons.check_rounded
                                              : Icons
                                                  .check_circle_outline_rounded,
                                          backgroundColor: _isCompleted
                                              ? AppColors.secondary
                                              : AppColors.primary,
                                          onPressed: _isCompleted
                                              ? null
                                              : _onMarkCompleted,
                                        ),
                                      ),

                                      // Next Lesson Button (Only when next lesson exists)
                                      if (_nextLesson != null) ...[
                                        const SizedBox(width: 10),
                                        IconButton.filled(
                                          style: IconButton.styleFrom(
                                            backgroundColor: _isCompleted
                                                ? AppColors.primary
                                                : AppColors
                                                    .surfaceContainerHigh,
                                            foregroundColor: _isCompleted
                                                ? Colors.white
                                                : AppColors.textMuted,
                                          ),
                                          icon: const Icon(
                                              Icons.arrow_forward_rounded),
                                          tooltip: _isCompleted
                                              ? 'Next: ${_nextLesson!.title}'
                                              : 'Complete lesson to unlock next',
                                          onPressed: () {
                                            if (!_isCompleted) {
                                              AppToast.showInfo(
                                                context,
                                                'Please complete the current lesson before moving to the next one.',
                                              );
                                              return;
                                            }
                                            context.pushReplacement(
                                              '/learning/${widget.courseId}/lesson/${_nextLesson!.id}',
                                            );
                                          },
                                        ),
                                      ] else if (_isCompleted) ...[
                                        const SizedBox(width: 10),
                                        IconButton.filled(
                                          style: IconButton.styleFrom(
                                            backgroundColor:
                                                AppColors.secondary,
                                            foregroundColor: Colors.white,
                                          ),
                                          icon: const Icon(
                                              Icons.celebration_rounded),
                                          tooltip:
                                              'Course Finished! Return to Course',
                                          onPressed: () => context.pop(),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
