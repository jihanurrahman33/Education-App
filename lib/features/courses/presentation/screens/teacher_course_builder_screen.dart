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

class TeacherCourseBuilderScreen extends StatefulWidget {
  final int? courseId;

  const TeacherCourseBuilderScreen({super.key, this.courseId});

  @override
  State<TeacherCourseBuilderScreen> createState() =>
      _TeacherCourseBuilderScreenState();
}

class _TeacherCourseBuilderScreenState extends State<TeacherCourseBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  String _category = 'Computer Science';
  String? _thumbnailName;

  final List<String> _categories = [
    'Computer Science',
    'Design & UI',
    'Business',
    'Data Science',
    'Engineering',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.courseId != null) {
      context
          .read<CourseBloc>()
          .add(FetchCourseDetailsRequested(widget.courseId!));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/dashboard');
    }
  }

  void _onSaveCourse() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.courseId == null) {
        context.read<CourseBloc>().add(
              CreateCourseRequested(
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
                isPublished: false,
              ),
            );
      } else {
        context.read<CourseBloc>().add(
              UpdateCourseRequested(
                courseId: widget.courseId!,
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
                isPublished: false,
              ),
            );
      }
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
            onPressed: _handleBack,
          ),
          title: const Text('Course Builder',
              style: TextStyle(color: AppColors.textPrimary)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: EmptyStateWidget(
              icon: Icons.hourglass_top_rounded,
              title: 'Account Approval Required',
              message:
                  'Your instructor account is currently undergoing administrative review. Course creation is locked until an administrator approves your instructor registration.',
              actionText: 'Check Application Status',
              onAction: () => context.push('/teacher/pending'),
            ),
          ),
        ),
      );
    }

    final isEditing = widget.courseId != null;

    return BlocConsumer<CourseBloc, CourseState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppToast.showError(context, state.errorMessage!);
        }
        if (state.successMessage != null) {
          AppToast.showSuccess(context, state.successMessage!);
          if (isEditing) {
            _handleBack();
          } else if (state.selectedCourse != null) {
            context.pushReplacement(
              '/teacher/courses/${state.selectedCourse!.id}/curriculum',
            );
          }
        }
        if (isEditing &&
            state.selectedCourse != null &&
            _titleController.text.isEmpty) {
          final course = state.selectedCourse!;
          _titleController.text = course.title;
          _descriptionController.text = course.description;
          _priceController.text = course.price.toString();
          if (course.category != null &&
              _categories.contains(course.category)) {
            _category = course.category!;
          }
        }
      },
      builder: (context, state) {
        final isSaving = state.status.isLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
              onPressed: _handleBack,
            ),
            title: Text(
              isEditing ? 'Edit Course Details' : 'Create New Course',
              style: const TextStyle(
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
                                const Text(
                                  'Course Basic Information',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: _titleController,
                                  label: 'Course Title',
                                  hint: 'e.g. Master Flutter & Clean Architecture',
                                  prefixIcon: Icons.title_rounded,
                                  validator: (val) =>
                                      (val == null || val.trim().isEmpty)
                                          ? 'Course title is required'
                                          : null,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Category',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: _category,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.category_rounded,
                                        color: AppColors.textSecondary),
                                  ),
                                  items: _categories.map((cat) {
                                    return DropdownMenuItem(value: cat, child: Text(cat));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _category = val);
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: _descriptionController,
                                  label: 'Course Description',
                                  hint:
                                      'Provide a detailed overview of skills students will gain...',
                                  maxLines: 4,
                                  validator: (val) =>
                                      (val == null || val.trim().isEmpty)
                                          ? 'Course description is required'
                                          : null,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: _priceController,
                                  label: 'Price (USD) - 0 for Free',
                                  hint: '0',
                                  keyboardType: TextInputType.number,
                                  prefixIcon: Icons.attach_money_rounded,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Reusable FileUploadBoxWidget for Course Thumbnail
                          FileUploadBoxWidget(
                            title: 'Course Cover / Thumbnail',
                            hintText: 'Tap to upload cover image (16:9 ratio)',
                            selectedFileName: _thumbnailName,
                            icon: Icons.add_photo_alternate_rounded,
                            onTap: () {
                              setState(
                                  () => _thumbnailName = 'course_cover_banner.png');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Selected course_cover_banner.png')),
                              );
                            },
                          ),
                          const SizedBox(height: 28),

                          CustomButton(
                            text: isEditing
                                ? 'Save Changes'
                                : 'Continue to Curriculum Builder',
                            icon: Icons.arrow_forward_rounded,
                            backgroundColor: AppColors.roleTeacher,
                            isLoading: isSaving,
                            onPressed: _onSaveCourse,
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
