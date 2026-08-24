import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class TeacherLessonCreateScreen extends StatefulWidget {
  final int courseId;
  final int chapterId;

  const TeacherLessonCreateScreen({
    super.key,
    required this.courseId,
    required this.chapterId,
  });

  @override
  State<TeacherLessonCreateScreen> createState() => _TeacherLessonCreateScreenState();
}

class _TeacherLessonCreateScreenState extends State<TeacherLessonCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _contentController = TextEditingController();

  String _lessonType = 'video'; // video or pdf
  String? _selectedFileName;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onUploadFile() {
    setState(() {
      _selectedFileName = _lessonType == 'video' ? 'lecture_module_03.mp4' : 'chapter_notes.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected $_selectedFileName for upload (multipart/form-data)'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  void _onSaveLesson() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lesson created and uploaded successfully!'),
          backgroundColor: AppColors.secondary,
        ),
      );
      context.pop();
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
          'Add New Lesson',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _titleController,
                      label: 'Lesson Title',
                      hint: 'e.g. Setting up Event BLoC Streams',
                      prefixIcon: Icons.play_lesson_rounded,
                      validator: (val) =>
                          (val == null || val.trim().isEmpty) ? 'Lesson title is required' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Lesson Content Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'video',
                          label: Text('Video Lecture'),
                          icon: Icon(Icons.videocam_rounded),
                        ),
                        ButtonSegment(
                          value: 'pdf',
                          label: Text('PDF / Document'),
                          icon: Icon(Icons.picture_as_pdf_rounded),
                        ),
                      ],
                      selected: {_lessonType},
                      onSelectionChanged: (set) {
                        setState(() {
                          _lessonType = set.first;
                          _selectedFileName = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _durationController,
                      label: 'Duration / Reading Time',
                      hint: 'e.g. 15 mins',
                      prefixIcon: Icons.timer_outlined,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _contentController,
                      label: 'Lesson Summary / Notes',
                      hint: 'Key concepts taught in this lesson...',
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // File Upload Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _lessonType == 'video' ? 'Upload Video Lecture File' : 'Upload PDF Notes Document',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _onUploadFile,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _lessonType == 'video'
                                  ? Icons.video_file_rounded
                                  : Icons.upload_file_rounded,
                              size: 36,
                              color: AppColors.roleTeacher,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedFileName ??
                                  'Tap to choose ${_lessonType == 'video' ? 'MP4 / WebM' : 'PDF'} file',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: _selectedFileName != null ? FontWeight.bold : FontWeight.normal,
                                color: _selectedFileName != null ? AppColors.secondary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Save & Add to Chapter',
                backgroundColor: AppColors.roleTeacher,
                onPressed: _onSaveLesson,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
