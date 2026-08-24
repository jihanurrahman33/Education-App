import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../courses/domain/entities/course_entity.dart';
import '../../../courses/domain/usecases/get_teacher_courses_usecase.dart';
import '../../domain/entities/teacher_dashboard_entity.dart';
import '../../domain/usecases/get_teacher_dashboard_use_case.dart';
import '../widgets/dashboard_stat_card_widget.dart';
import '../widgets/teacher_verification_banner_widget.dart';

class TeacherDashboardScreen extends StatefulWidget {
  final UserEntity user;

  const TeacherDashboardScreen({super.key, required this.user});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final GetTeacherDashboardUseCase _getTeacherDashboardUseCase = GetIt.I<GetTeacherDashboardUseCase>();
  final GetTeacherCoursesUseCase _getTeacherCoursesUseCase = GetIt.I<GetTeacherCoursesUseCase>();

  TeacherDashboardEntity _dashboardData = const TeacherDashboardEntity();
  List<CourseEntity> _teacherCourses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }

  Future<void> _loadTeacherData() async {
    setState(() => _isLoading = true);

    final results = await Future.wait([
      _getTeacherDashboardUseCase(const NoParams()),
      _getTeacherCoursesUseCase(),
    ]);

    if (!mounted) return;

    final dashRes = results[0];
    final coursesRes = results[1];

    TeacherDashboardEntity dashboardData = const TeacherDashboardEntity();
    List<CourseEntity> courses = [];

    dashRes.fold((_) => null, (data) => dashboardData = data as TeacherDashboardEntity);
    coursesRes.fold((_) => null, (data) => courses = data as List<CourseEntity>);

    setState(() {
      _dashboardData = dashboardData;
      _teacherCourses = courses;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadTeacherData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teacher Status Warning Banner
            if (!widget.user.isApprovedTeacher) ...[
              TeacherVerificationBannerWidget(
                onTap: () => context.push('/teacher/pending'),
              ),
              const SizedBox(height: 20),
            ],

            // Welcome Instructor Banner
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.roleTeacher, Color(0xFF5B21B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.roleTeacher.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Instructor Portal - ${widget.user.fullName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Create courses, upload video lessons, and build quizzes.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.cast_for_education_rounded,
                    size: 44,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Teacher Stats Row
            Row(
              children: [
                DashboardStatCardWidget(
                  title: 'Authored',
                  count: '${_dashboardData.authoredCoursesCount} Courses',
                  icon: Icons.menu_book_rounded,
                  color: AppColors.roleTeacher,
                ),
                const SizedBox(width: 10),
                DashboardStatCardWidget(
                  title: 'Enrolled',
                  count: '${_dashboardData.totalStudentsEnrolled} Students',
                  icon: Icons.groups_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                DashboardStatCardWidget(
                  title: 'Quizzes',
                  count: '${_dashboardData.activeQuizzesCount} Active',
                  icon: Icons.quiz_rounded,
                  color: AppColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Teacher Action Bar
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Create New Course',
                    icon: Icons.add_circle_outline_rounded,
                    backgroundColor: AppColors.roleTeacher,
                    onPressed: () => context.push('/teacher/courses/create'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: 'Manage Quizzes',
                    icon: Icons.quiz_outlined,
                    isOutlined: true,
                    backgroundColor: AppColors.roleTeacher,
                    textColor: AppColors.roleTeacher,
                    onPressed: () => context.push('/teacher/quizzes'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            const Text(
              'My Authored Courses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            if (_isLoading)
              const LoadingSkeletonCard(height: 120, borderRadius: 14)
            else if (_teacherCourses.isEmpty)
              Container(
                padding: const EdgeInsets.all(28.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.school_outlined, size: 40, color: AppColors.textSecondary),
                    const SizedBox(height: 8),
                    const Text(
                      'You haven\'t published any courses yet.',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create Course'),
                      onPressed: () => context.push('/teacher/courses/create'),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _teacherCourses.length,
                itemBuilder: (context, index) {
                  final course = _teacherCourses[index];
                  final isPublished = course.isPublished;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isPublished
                                      ? AppColors.secondary.withValues(alpha: 0.12)
                                      : AppColors.warning.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isPublished ? 'Published' : 'Draft / Pending',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isPublished ? AppColors.secondary : AppColors.warning,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    tooltip: 'Edit Course',
                                    onPressed: () => context.push('/teacher/courses/${course.id}/edit'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.menu_book_rounded, size: 18, color: AppColors.primary),
                                    tooltip: 'Curriculum & Lessons',
                                    onPressed: () => context.push('/teacher/courses/${course.id}/curriculum'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            course.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${course.chaptersCount} Chapters • ${course.lessonsCount} Lessons',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
