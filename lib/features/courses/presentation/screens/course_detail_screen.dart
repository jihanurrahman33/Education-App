import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(FetchCourseDetailsRequested(widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state.status.isLoading && state.selectedCourse == null) {
            return const LoadingView(message: 'Loading course details...');
          }

          if (state.status.isError && state.selectedCourse == null) {
            return ErrorView(
              message: state.errorMessage ?? 'Failed to load course details',
              onRetry: () => context
                  .read<CourseBloc>()
                  .add(FetchCourseDetailsRequested(widget.courseId)),
            );
          }

          final course = state.selectedCourse;
          if (course == null) {
            return const Center(child: Text('Course not found'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (course.category != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            course.category!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(
                        course.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Instructor: ${course.instructorName ?? "Instructor"}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        'About this Course',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course.description,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: course.isEnrolled ? 'Continue Learning' : 'Enroll Now',
                        isLoading: state.isEnrolling,
                        onPressed: () {
                          if (!course.isEnrolled) {
                            context
                                .read<CourseBloc>()
                                .add(EnrollCourseRequested(course.id));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
