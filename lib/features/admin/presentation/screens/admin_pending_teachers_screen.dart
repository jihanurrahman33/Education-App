import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';
import '../widgets/admin_pending_teacher_card.dart';

class AdminPendingTeachersScreen extends StatefulWidget {
  const AdminPendingTeachersScreen({super.key});

  @override
  State<AdminPendingTeachersScreen> createState() =>
      _AdminPendingTeachersScreenState();
}

class _AdminPendingTeachersScreenState
    extends State<AdminPendingTeachersScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<AdminBloc>().add(const LoadPendingTeachersEvent());
  }

  void _onApprove(int id, String name) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Approve Teacher Application',
      message:
          'Are you sure you want to approve $name as an authorized EduFlow instructor?',
      confirmText: 'Approve Teacher',
      confirmColor: AppColors.secondary,
      icon: Icons.how_to_reg_rounded,
    );

    if (confirmed == true && mounted) {
      context.read<AdminBloc>().add(ApproveTeacherEvent(id));
    }
  }

  void _onReject(int id, String name) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Reject Application',
      message:
          'Are you sure you want to reject and remove $name\'s instructor registration application?',
      confirmText: 'Reject & Remove',
      confirmColor: AppColors.error,
      icon: Icons.person_off_rounded,
    );

    if (confirmed == true && mounted) {
      context.read<AdminBloc>().add(DeleteAdminUserEvent(id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name\'s application was rejected.'),
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
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Pending Teacher Approvals',
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
            onPressed: _loadData,
          ),
        ],
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.error),
            );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: AppColors.secondary),
            );
          }
        },
        builder: (context, state) {
          final isLoading =
              state.status == AdminStatus.loading && state.pendingTeachers.isEmpty;

          if (isLoading) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  itemBuilder: (context, index) =>
                      const LoadingSkeletonCard(height: 130, borderRadius: 16),
                ),
              ),
            );
          }

          if (state.status == AdminStatus.failure &&
              state.pendingTeachers.isEmpty) {
            return Center(
              child: ErrorView(
                message: state.errorMessage ??
                    'Failed to retrieve pending teacher applications.',
                onRetry: _loadData,
              ),
            );
          }

          if (state.pendingTeachers.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => _loadData(),
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: EmptyStateWidget(
                      icon: Icons.check_circle_outline_rounded,
                      title: 'All Caught Up!',
                      message:
                          'There are no pending teacher applications awaiting administrative approval.',
                      actionText: 'Refresh List',
                      onAction: _loadData,
                    ),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: RefreshIndicator(
                    onRefresh: () async => _loadData(),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 24.0 : 16.0,
                        vertical: 16.0,
                      ),
                      itemCount: state.pendingTeachers.length,
                      itemBuilder: (context, index) {
                        final teacher = state.pendingTeachers[index];
                        return AdminPendingTeacherCard(
                          teacherEntity: teacher,
                          onApprove: () =>
                              _onApprove(teacher.id, teacher.fullName),
                          onReject: () =>
                              _onReject(teacher.id, teacher.fullName),
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
