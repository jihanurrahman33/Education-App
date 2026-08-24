import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/domain/entities/user_entity.dart';

class TeacherDashboardScreen extends StatelessWidget {
  final UserEntity user;

  const TeacherDashboardScreen({super.key, required this.user});

  final List<Map<String, dynamic>> mockAuthoredCourses = const [
    {
      'id': 1,
      'title': 'Full-Stack Modern App Architecture',
      'studentsCount': 128,
      'status': 'Published',
      'chaptersCount': 4,
      'lessonsCount': 16,
    },
    {
      'id': 2,
      'title': 'Advanced Dart Generics & Concurrency',
      'studentsCount': 0,
      'status': 'Pending Approval',
      'chaptersCount': 3,
      'lessonsCount': 9,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teacher Status Banner
          if (!user.isApprovedTeacher) ...[
            InkWell(
              onTap: () => context.push('/teacher/pending'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.pending_actions_rounded, color: AppColors.warning),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Pending Admin Approval',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Tap to check your application review status.',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppColors.warning),
                  ],
                ),
              ),
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
                        'Instructor Portal - ${user.fullName}',
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

          // Teacher Stats
          Row(
            children: [
              _buildStatCard('Authored', '2 Courses', Icons.menu_book_rounded, AppColors.roleTeacher),
              const SizedBox(width: 10),
              _buildStatCard('Enrolled', '128 Students', Icons.groups_rounded, AppColors.primary),
              const SizedBox(width: 10),
              _buildStatCard('Quizzes', '3 Active', Icons.quiz_rounded, AppColors.secondary),
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

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockAuthoredCourses.length,
            itemBuilder: (context, index) {
              final course = mockAuthoredCourses[index];
              final isPublished = course['status'] == 'Published';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                              course['status'] as String,
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
                                onPressed: () => context.push('/teacher/courses/${course['id']}/edit'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.menu_book_rounded, size: 18, color: AppColors.primary),
                                tooltip: 'Curriculum & Lessons',
                                onPressed: () => context.push('/teacher/courses/${course['id']}/curriculum'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${course['chaptersCount']} Chapters • ${course['lessonsCount']} Lessons • ${course['studentsCount']} Active Students',
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
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
