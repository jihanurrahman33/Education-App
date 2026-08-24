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
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
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
  State<TeacherLessonCreateScreen> createState() =>
      _TeacherLessonCreateScreenState();
}

class _TeacherLessonCreateScreenState extends State<TeacherLessonCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _contentController = TextEditingController();

  String _lessonType = 'video'; // video or pdf
  String? _selectedFileName;
  String? _selectedFilePath;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onUploadFile() {
    setState(() {
      _selectedFileName =
          _lessonType == 'video' ? 'lecture_video.mp4' : 'lecture_notes.pdf';
    });
    AppToast.showSuccess(
        context, 'Selected $_selectedFileName for upload (multipart/form-data)');
  }

  void _onSaveLesson() {
    if (_formKey.currentState?.validate() ?? false) {
      final durationText =
          _durationController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final duration = int.tryParse(durationText) ?? 0;

      context.read<CourseBloc>().add(
            CreateLessonRequested(
              chapterId: widget.chapterId,
              title: _titleController.text.trim(),
              lessonType: _lessonType,
              textContent: _contentController.text.trim(),
              durationMinutes: duration,
              videoFilePath: _lessonType == 'video' ? _selectedFilePath : null,
              pdfFilePath: _lessonType == 'pdf' ? _selectedFilePath : null,
              order: 1,
            ),
          );
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
          title: const Text('Add Lesson',
              style: TextStyle(color: AppColors.textPrimary)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: EmptyStateWidget(
              icon: Icons.hourglass_top_rounded,
              title: 'Account Approval Required',
              message:
                  'Your instructor account is currently undergoing administrative review. Adding lessons and uploading files is locked until an administrator approves your instructor registration.',
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
          context.pop();
        }
      },
      builder: (context, state) {
        final isLoading = state.status.isLoading;

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
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 32.0 : 20.0,
                      vertical: 20.0,
                    ),
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
                                      (val == null || val.trim().isEmpty)
                                          ? 'Lesson title is required'
                                          : null,
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
                            title: _lessonType == 'video'
                                ? 'Upload Video Lecture File'
                                : 'Upload PDF Notes Document',
                            hintText:
                                'Tap to choose ${_lessonType == 'video' ? 'MP4 / WebM' : 'PDF'} file',
                            selectedFileName: _selectedFileName,
                            icon: _lessonType == 'video'
                                ? Icons.video_file_rounded
                                : Icons.upload_file_rounded,
                            onTap: _onUploadFile,
                          ),
                          const SizedBox(height: 28),

                          CustomButton(
                            text: 'Save & Add to Chapter',
                            backgroundColor: AppColors.roleTeacher,
                            isLoading: isLoading,
                            onPressed: _onSaveLesson,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
