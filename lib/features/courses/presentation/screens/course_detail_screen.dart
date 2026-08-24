import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../../progress/presentation/bloc/progress_event.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../../domain/entities/course_entity.dart';
import '../widgets/curriculum_accordion_widget.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCourseDetails();
  }

  void _loadCourseDetails() {
    context
        .read<CourseBloc>()
        .add(FetchCourseDetailsRequested(widget.courseId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onEnroll(int courseId, String courseTitle) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Confirm Course Enrollment',
      message:
          'Are you ready to enroll in "$courseTitle"? You will get instant access to all chapters, lessons, and quizzes.',
      confirmText: 'Enroll Now',
      icon: Icons.school_rounded,
    );

    if (confirmed == true && mounted) {
      context.read<CourseBloc>().add(EnrollCourseRequested(courseId));
    }
  }

  int? _findFirstLessonId(CourseEntity course) {
    for (final chapter in course.chapters) {
      if (chapter.lessons.isNotEmpty) {
        return chapter.lessons.first.id;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Course Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
            tooltip: 'Refresh',
            onPressed: _loadCourseDetails,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primary),
            tooltip: 'Share',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Course link copied to clipboard!')),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.secondary,
              ),
            );
            // Refresh student progress overview
            context.read<ProgressBloc>().add(const LoadMyProgressEvent());
            context.read<ProgressBloc>().add(const LoadEnrollmentsEvent());
          }
        },
        builder: (context, state) {
          if (state.status.isLoading && state.selectedCourse == null) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  LoadingSkeletonCard(height: 200),
                  SizedBox(height: 12),
                  LoadingSkeletonCard(height: 120),
                ],
              ),
            );
          }

          if (state.status.isError && state.selectedCourse == null) {
            return Center(
              child: ErrorView(
                message: state.errorMessage ??
                    'Please check your connection and try again.',
                onRetry: _loadCourseDetails,
              ),
            );
          }

          final course = state.selectedCourse;
          if (course == null) {
            return const Center(
              child: EmptyStateWidget(
                title: 'Course Not Found',
                message:
                    'This course might have been removed or is undergoing administrative review.',
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    children: [
                      // Hero Preview Banner
                      Container(
                        height: isWide ? 220 : 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.secondary.withValues(alpha: 0.8),
                              AppColors.surface,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: const Border(
                            bottom: BorderSide(color: AppColors.border),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 38,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Curriculum Syllabus Overview',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: course.isEnrolled
                                      ? AppColors.secondary
                                      : AppColors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  course.isEnrolled
                                      ? 'ENROLLED'
                                      : (course.price == 0
                                          ? 'FREE ACCESS'
                                          : '\$${course.price.toStringAsFixed(2)}'),
                                  style: TextStyle(
                                    color: course.isEnrolled
                                        ? Colors.white
                                        : AppColors.onPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tab Selector
                      Container(
                        color: AppColors.background,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textSecondary,
                          indicatorColor: AppColors.primary,
                          indicatorWeight: 3,
                          dividerColor: AppColors.divider,
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                          unselectedLabelStyle: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Curriculum'),
                            Tab(text: 'Instructor'),
                          ],
                        ),
                      ),

                      // Tab Views
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Tab 1: Overview
                            _buildOverviewTab(course),
                            // Tab 2: Curriculum
                            CurriculumAccordionWidget(
                              chapters: course.chapters,
                              isEnrolled: course.isEnrolled,
                              onLessonTap: (lesson) {
                                if (course.isEnrolled) {
                                  context.push(
                                      '/learning/${course.id}/lesson/${lesson.id}');
                                } else {
                                  _onEnroll(course.id, course.title);
                                }
                              },
                            ),
                            // Tab 3: Instructor
                            _buildInstructorTab(course),
                          ],
                        ),
                      ),

                      // Bottom Enrollment Action Bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          border: Border(
                            top: BorderSide(color: AppColors.border),
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Access Status',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    course.isEnrolled
                                        ? 'Enrolled'
                                        : (course.price == 0
                                            ? 'Free'
                                            : '\$${course.price.toStringAsFixed(2)}'),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: course.isEnrolled
                                          ? AppColors.secondary
                                          : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: CustomButton(
                                  text: course.isEnrolled
                                      ? 'Continue Course'
                                      : 'Enroll in Course',
                                  icon: course.isEnrolled
                                      ? Icons.play_circle_filled_rounded
                                      : Icons.school_rounded,
                                  isLoading: state.isEnrolling,
                                  backgroundColor: course.isEnrolled
                                      ? AppColors.secondary
                                      : AppColors.primary,
                                  textColor: course.isEnrolled
                                      ? Colors.white
                                      : AppColors.onPrimary,
                                  onPressed: () {
                                    if (course.isEnrolled) {
                                      final firstLessonId =
                                          _findFirstLessonId(course);
                                      if (firstLessonId != null) {
                                        context.push(
                                            '/learning/${course.id}/lesson/$firstLessonId');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'No lessons available yet in this course.'),
                                          ),
                                        );
                                      }
                                    } else {
                                      _onEnroll(course.id, course.title);
                                    }
                                  },
                                ),
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
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(CourseEntity course) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Metadata Pills Row
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  course.category ?? 'Computer Science',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.star_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              const Text(
                '4.9 (1.2k ratings)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(width: 10),
              Text(
                '• ${course.lessonsCount} lessons',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Course Features
          const Text(
            'What you will get:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildHighlightItem(
              Icons.all_inclusive_rounded, 'Full lifetime access to curriculum'),
          _buildHighlightItem(Icons.workspace_premium_rounded,
              'Official verified certificate of completion'),
          _buildHighlightItem(Icons.quiz_rounded,
              'Interactive quizzes & knowledge checks'),
          _buildHighlightItem(
              Icons.devices_rounded, 'Access on mobile and tablet'),

          const SizedBox(height: 20),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 16),

          // About Description
          const Text(
            'About this Course',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            course.description.isNotEmpty
                ? course.description
                : 'Master concepts with hands-on examples, step-by-step modular lessons, and comprehensive assessment quizzes.',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style:
                  const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorTab(CourseEntity course) {
    final instructorName = course.instructorName ?? 'Lead Instructor';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: Text(
                instructorName.isNotEmpty
                    ? instructorName[0].toUpperCase()
                    : 'I',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              instructorName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Certified EduFlow Senior Educator',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Passionate about delivering structured, industry-relevant curriculum to thousands of developers and designers worldwide.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
