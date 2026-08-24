import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../domain/entities/admin_course_entity.dart';
import '../../domain/usecases/approve_course_use_case.dart';
import '../../domain/usecases/get_pending_courses_use_case.dart';
import '../../domain/usecases/reject_course_use_case.dart';
import '../widgets/admin_pending_course_card.dart';

class AdminPendingCoursesScreen extends StatefulWidget {
  const AdminPendingCoursesScreen({super.key});

  @override
  State<AdminPendingCoursesScreen> createState() => _AdminPendingCoursesScreenState();
}

class _AdminPendingCoursesScreenState extends State<AdminPendingCoursesScreen> {
  final GetPendingCoursesUseCase _getPendingCoursesUseCase = GetIt.I<GetPendingCoursesUseCase>();
  final ApproveCourseUseCase _approveCourseUseCase = GetIt.I<ApproveCourseUseCase>();
  final RejectCourseUseCase _rejectCourseUseCase = GetIt.I<RejectCourseUseCase>();

  List<AdminCourseEntity> _pendingCourses = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPendingCourses();
  }

  Future<void> _fetchPendingCourses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _getPendingCoursesUseCase(const GetPendingCoursesParams());

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
      },
      (courses) {
        setState(() {
          _isLoading = false;
          _pendingCourses = courses;
        });
      },
    );
  }

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
      final result = await _approveCourseUseCase(id);

      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to approve course: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (_) {
          setState(() {
            _pendingCourses.removeWhere((c) => c.id == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Course "$title" approved and published!'),
              backgroundColor: AppColors.secondary,
            ),
          );
        },
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
      final result = await _rejectCourseUseCase(id);

      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to reject course: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (_) {
          setState(() {
            _pendingCourses.removeWhere((c) => c.id == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Course "$title" rejected.'),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
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
            onPressed: _fetchPendingCourses,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (_, index) => const LoadingSkeletonCard(height: 140, borderRadius: 16),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.onSurface, fontSize: 15),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchPendingCourses,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_pendingCourses.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchPendingCourses,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: EmptyStateWidget(
                icon: Icons.verified_rounded,
                title: 'No Pending Course Submissions',
                message: 'All submitted teacher courses have been reviewed and processed.',
                actionText: 'Back to Dashboard',
                onAction: () => context.go('/dashboard'),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPendingCourses,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingCourses.length,
        itemBuilder: (context, index) {
          final course = _pendingCourses[index];

          return AdminPendingCourseCard(
            courseEntity: course,
            onReview: () => context.push('/admin/courses/${course.id}/review'),
            onApprove: () => _onApproveCourse(course.id, course.title),
            onReject: () => _onRejectCourse(course.id, course.title),
          );
        },
      ),
    );
  }
}
