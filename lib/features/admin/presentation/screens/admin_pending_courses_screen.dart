import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class AdminPendingCoursesScreen extends StatefulWidget {
  const AdminPendingCoursesScreen({super.key});

  @override
  State<AdminPendingCoursesScreen> createState() => _AdminPendingCoursesScreenState();
}

class _AdminPendingCoursesScreenState extends State<AdminPendingCoursesScreen> {
  final List<Map<String, dynamic>> _pendingCourses = [
    {
      'id': 201,
      'title': 'Advanced Microservices with Dart & Docker',
      'instructor': 'Dr. Robert Smith',
      'category': 'Computer Science',
      'submittedDate': 'Aug 23, 2026',
      'chaptersCount': 5,
      'lessonsCount': 22,
    },
    {
      'id': 202,
      'title': 'Design Token Automation in Production Apps',
      'instructor': 'Clara Oswald',
      'category': 'Design & UI',
      'submittedDate': 'Aug 22, 2026',
      'chaptersCount': 3,
      'lessonsCount': 12,
    },
  ];

  void _onApproveCourse(int id, String title) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Approve Course Publication',
      message: 'Approving "$title" will immediately make it visible to all students in the public explore catalog.',
      confirmText: 'Approve & Publish',
      confirmColor: AppColors.secondary,
      icon: Icons.check_circle_rounded,
    );

    if (confirmed == true && mounted) {
      setState(() {
        _pendingCourses.removeWhere((c) => c['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course "$title" approved and published!'),
          backgroundColor: AppColors.secondary,
        ),
      );
    }
  }

  void _onRejectCourse(int id, String title) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Reject Course Draft',
      message: 'Rejecting "$title" will send feedback to the instructor to revise the course material.',
      confirmText: 'Reject Course',
      confirmColor: AppColors.error,
      icon: Icons.cancel_rounded,
    );

    if (confirmed == true && mounted) {
      setState(() {
        _pendingCourses.removeWhere((c) => c['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course "$title" rejected.'),
          backgroundColor: AppColors.error,
        ),
      );
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
          'Pending Course Approvals',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _pendingCourses.isEmpty
          ? EmptyStateWidget(
              icon: Icons.verified_rounded,
              title: 'No Pending Course Submissions',
              message: 'All submitted teacher courses have been reviewed and processed.',
              actionText: 'Back to Dashboard',
              onAction: () => context.go('/dashboard'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pendingCourses.length,
              itemBuilder: (context, index) {
                final course = _pendingCourses[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                (course['category'] as String).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Text(
                              'Submitted ${course['submittedDate']}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          course['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Author: ${course['instructor']} • ${course['chaptersCount']} Chapters • ${course['lessonsCount']} Lessons',
                          style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.preview_rounded, size: 16),
                              label: const Text('Review Curriculum'),
                              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                              onPressed: () => context.push('/admin/courses/${course['id']}/review'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(color: AppColors.error),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _onRejectCourse(course['id'] as int, course['title'] as String),
                              child: const Text('Reject'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check_rounded, size: 16),
                              label: const Text('Approve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _onApproveCourse(course['id'] as int, course['title'] as String),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
