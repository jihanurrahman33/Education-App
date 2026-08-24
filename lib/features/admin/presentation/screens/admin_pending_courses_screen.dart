import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../widgets/admin_pending_course_card.dart';

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

                return AdminPendingCourseCard(
                  course: course,
                  onReview: () => context.push('/admin/courses/${course['id']}/review'),
                  onApprove: () => _onApproveCourse(course['id'] as int, course['title'] as String),
                  onReject: () => _onRejectCourse(course['id'] as int, course['title'] as String),
                );
              },
            ),
    );
  }
}
