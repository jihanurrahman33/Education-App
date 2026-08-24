import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';
import '../widgets/admin_pending_course_card.dart';

class AdminPendingCoursesScreen extends StatefulWidget {
  const AdminPendingCoursesScreen({super.key});

  @override
  State<AdminPendingCoursesScreen> createState() => _AdminPendingCoursesScreenState();
}

class _AdminPendingCoursesScreenState extends State<AdminPendingCoursesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const LoadPendingCoursesEvent());
  }

  void _onApproveCourse(int id, String title) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Approve Course Publication',
      message:
          'Approving "$title" will immediately make it visible to all students in the public explore catalog.',
      confirmText: 'Approve & Publish',
      confirmColor: AppColors.secondary,
      icon: Icons.check_circle_rounded,
    );

    if (confirmed == true && mounted) {
      context.read<AdminBloc>().add(ApproveCourseEvent(id));
    }
  }

  void _onRejectCourse(int id, String title) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Reject Course Draft',
      message:
          'Rejecting "$title" will send feedback to the instructor to revise the course material.',
      confirmText: 'Reject Course',
      confirmColor: AppColors.error,
      icon: Icons.cancel_rounded,
    );

    if (confirmed == true && mounted) {
      context.read<AdminBloc>().add(RejectCourseEvent(id));
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
          'Pending Course Approvals',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
            tooltip: 'Refresh',
            onPressed: () => context.read<AdminBloc>().add(const LoadPendingCoursesEvent()),
          ),
        ],
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error),
            );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.secondary),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AdminStatus.loading && state.pendingCourses.isEmpty;

          if (isLoading) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  itemBuilder: (_, index) =>
                      const LoadingSkeletonCard(height: 140, borderRadius: 16),
                ),
              ),
            );
          }

          if (state.pendingCourses.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AdminBloc>().add(const LoadPendingCoursesEvent());
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: EmptyStateWidget(
                      icon: Icons.verified_rounded,
                      title: 'No Pending Course Submissions',
                      message:
                          'All submitted teacher courses have been reviewed and processed.',
                      actionText: 'Back to Dashboard',
                      onAction: () => context.go('/dashboard'),
                    ),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<AdminBloc>().add(const LoadPendingCoursesEvent());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.pendingCourses.length,
                      itemBuilder: (context, index) {
                        final course = state.pendingCourses[index];
                        return AdminPendingCourseCard(
                          courseEntity: course,
                          onReview: () =>
                              context.push('/admin/courses/${course.id}/review'),
                          onApprove: () =>
                              _onApproveCourse(course.id, course.title),
                          onReject: () =>
                              _onRejectCourse(course.id, course.title),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
