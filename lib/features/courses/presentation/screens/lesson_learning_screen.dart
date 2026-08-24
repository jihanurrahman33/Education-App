import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
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
  bool _isPlaying = true;
  double _videoProgress = 0.45;
  bool _isCompleted = false;
  bool _showingNotes = false;

  void _onMarkCompleted() {
    setState(() {
      _isCompleted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('Lesson marked as completed! Course progress updated.'),
          ],
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Lesson ${widget.lessonId}',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showingNotes ? Icons.videocam_rounded : Icons.description_rounded,
              color: Colors.white,
            ),
            tooltip: _showingNotes ? 'Switch to Video' : 'View PDF Notes',
            onPressed: () {
              setState(() {
                _showingNotes = !_showingNotes;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Reusable Media Player / PDF Viewer Container
          if (!_showingNotes)
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening PDF reader viewer...')),
                );
              },
            ),

          // Content & Navigation Container
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Chapter 2 • Lesson ${widget.lessonId}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      if (_isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_rounded, size: 14, color: AppColors.secondary),
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
                  const Text(
                    'Building Responsive State Architectures with BLoC',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'In this lesson, we break down event-driven state streams, error boundaries, and reactive presentation updates.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),

                  // Bottom Action Bar
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: _isCompleted ? 'Completed' : 'Mark Complete',
                          icon: _isCompleted ? Icons.check_rounded : Icons.check_circle_outline_rounded,
                          backgroundColor:
                              _isCompleted ? AppColors.secondary : AppColors.primary,
                          onPressed: _isCompleted ? null : _onMarkCompleted,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerHigh,
                          foregroundColor: AppColors.onSurface,
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        tooltip: 'Next Lesson',
                        onPressed: () {
                          context.pushReplacement(
                            '/learning/${widget.courseId}/lesson/${widget.lessonId + 1}',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
