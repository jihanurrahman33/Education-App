import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/usecases/create_course_usecase.dart';
import '../../domain/usecases/get_course_details_usecase.dart';
import '../widgets/file_upload_box_widget.dart';

class TeacherCourseBuilderScreen extends StatefulWidget {
  final int? courseId;

  const TeacherCourseBuilderScreen({super.key, this.courseId});

  @override
  State<TeacherCourseBuilderScreen> createState() => _TeacherCourseBuilderScreenState();
}

class _TeacherCourseBuilderScreenState extends State<TeacherCourseBuilderScreen> {
  final CreateCourseUseCase _createCourseUseCase = GetIt.I<CreateCourseUseCase>();
  final GetCourseDetailsUseCase _getCourseDetailsUseCase = GetIt.I<GetCourseDetailsUseCase>();

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  String _category = 'Computer Science';
  String? _thumbnailName;
  bool _isLoading = false;
  bool _isSaving = false;

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
      _loadExistingCourse(widget.courseId!);
    }
  }

  Future<void> _loadExistingCourse(int id) async {
    setState(() => _isLoading = true);
    final result = await _getCourseDetailsUseCase(GetCourseDetailsParams(courseId: id));
    if (!mounted) return;

    result.fold(
      (failure) => setState(() => _isLoading = false),
      (course) {
        setState(() {
          _titleController.text = course.title;
          _descriptionController.text = course.description;
          _priceController.text = course.price.toString();
          if (course.category != null && _categories.contains(course.category)) {
            _category = course.category!;
          }
          _isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _onSaveCourse() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);

      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      if (widget.courseId == null) {
        // Create new course
        final result = await _createCourseUseCase(CreateCourseParams(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _category,
          price: price,
          isPublished: false,
        ));

        if (!mounted) return;
        setState(() => _isSaving = false);

        result.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create course: ${failure.message}'),
                backgroundColor: AppColors.error,
              ),
            );
          },
          (created) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Course "${created.title}" created successfully!'),
                backgroundColor: AppColors.secondary,
              ),
            );
            context.pushReplacement('/teacher/courses/${created.id}/curriculum');
          },
        );
      } else {
        // Edit course saved
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Course details updated successfully!'),
            backgroundColor: AppColors.secondary,
          ),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.courseId != null;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditing ? 'Edit Course Details' : 'Create New Course',
          style: const TextStyle(
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
                          (val == null || val.trim().isEmpty) ? 'Course title is required' : null,
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
                        prefixIcon: Icon(Icons.category_rounded, color: AppColors.textSecondary),
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
                      hint: 'Provide a detailed overview of skills students will gain...',
                      maxLines: 4,
                      validator: (val) => (val == null || val.trim().isEmpty)
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
                  setState(() => _thumbnailName = 'course_cover_banner.png');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Selected course_cover_banner.png')),
                  );
                },
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: isEditing ? 'Save Changes' : 'Continue to Curriculum Builder',
                icon: Icons.arrow_forward_rounded,
                backgroundColor: AppColors.roleTeacher,
                isLoading: _isSaving,
                onPressed: _onSaveCourse,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
