import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/usecases/create_lesson_usecase.dart';
import '../widgets/file_upload_box_widget.dart';

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
  final CreateLessonUseCase _createLessonUseCase = GetIt.I<CreateLessonUseCase>();

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _contentController = TextEditingController();

  String _lessonType = 'video'; // video or pdf
  String? _selectedFileName;
  String? _selectedFilePath;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onUploadFile() {
    setState(() {
      _selectedFileName = _lessonType == 'video' ? 'lecture_video.mp4' : 'lecture_notes.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected $_selectedFileName for upload (multipart/form-data)'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  Future<void> _onSaveLesson() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final durationText = _durationController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final duration = int.tryParse(durationText) ?? 0;

      final result = await _createLessonUseCase(CreateLessonParams(
        chapterId: widget.chapterId,
        title: _titleController.text.trim(),
        lessonType: _lessonType,
        textContent: _contentController.text.trim(),
        durationMinutes: duration,
        videoFilePath: _lessonType == 'video' ? _selectedFilePath : null,
        pdfFilePath: _lessonType == 'pdf' ? _selectedFilePath : null,
        order: 1,
      ));

      if (!mounted) return;
      setState(() => _isLoading = false);

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create lesson: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (lesson) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lesson "${lesson.title}" created successfully!'),
              backgroundColor: AppColors.secondary,
            ),
          );
          context.pop();
        },
      );
    }
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
          'Add New Lesson',
          style: TextStyle(
            color: AppColors.textPrimary,
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
                  color: AppColors.surface,
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
                          _selectedFilePath = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _durationController,
                      label: 'Duration / Reading Time (Minutes)',
                      hint: '15',
                      keyboardType: TextInputType.number,
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

              // Reusable FileUploadBoxWidget
              FileUploadBoxWidget(
                title: _lessonType == 'video' ? 'Upload Video Lecture File' : 'Upload PDF Notes Document',
                hintText: 'Tap to choose ${_lessonType == 'video' ? 'MP4 / WebM' : 'PDF'} file',
                selectedFileName: _selectedFileName,
                icon: _lessonType == 'video' ? Icons.video_file_rounded : Icons.upload_file_rounded,
                onTap: _onUploadFile,
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Save & Add to Chapter',
                backgroundColor: AppColors.roleTeacher,
                isLoading: _isLoading,
                onPressed: _onSaveLesson,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
