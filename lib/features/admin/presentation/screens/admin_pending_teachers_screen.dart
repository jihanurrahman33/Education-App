import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../../domain/usecases/approve_teacher_use_case.dart';
import '../../domain/usecases/get_pending_teachers_use_case.dart';
import '../widgets/admin_pending_teacher_card.dart';

class AdminPendingTeachersScreen extends StatefulWidget {
  const AdminPendingTeachersScreen({super.key});

  @override
  State<AdminPendingTeachersScreen> createState() => _AdminPendingTeachersScreenState();
}

class _AdminPendingTeachersScreenState extends State<AdminPendingTeachersScreen> {
  final GetPendingTeachersUseCase _getPendingTeachersUseCase = GetIt.I<GetPendingTeachersUseCase>();
  final ApproveTeacherUseCase _approveTeacherUseCase = GetIt.I<ApproveTeacherUseCase>();

  List<AdminUserEntity> _pendingTeachers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPendingTeachers();
  }

  Future<void> _fetchPendingTeachers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _getPendingTeachersUseCase(const GetPendingTeachersParams());

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
      },
      (teachers) {
        setState(() {
          _isLoading = false;
          _pendingTeachers = teachers;
        });
      },
    );
  }

  void _onApprove(int id, String name) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Approve Teacher Application',
      message: 'Are you sure you want to approve $name as an authorized EduFlow instructor?',
      confirmText: 'Approve Teacher',
      confirmColor: AppColors.secondary,
      icon: Icons.how_to_reg_rounded,
    );

    if (confirmed == true && mounted) {
      final result = await _approveTeacherUseCase(id);

      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to approve teacher: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (_) {
          setState(() {
            _pendingTeachers.removeWhere((t) => t.id == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$name has been approved as an instructor!'),
              backgroundColor: AppColors.secondary,
            ),
          );
        },
      );
    }
  }

  void _onReject(int id, String name) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Reject Application',
      message: 'Are you sure you want to reject $name\'s instructor registration?',
      confirmText: 'Reject',
      confirmColor: AppColors.error,
      icon: Icons.person_off_rounded,
    );

    if (confirmed == true && mounted) {
      setState(() {
        _pendingTeachers.removeWhere((t) => t.id == id);
      });
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
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Pending Teacher Approvals',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
            tooltip: 'Refresh',
            onPressed: _fetchPendingTeachers,
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
        itemBuilder: (_, index) => const LoadingSkeletonCard(height: 130, borderRadius: 16),
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
                onPressed: _fetchPendingTeachers,
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

    if (_pendingTeachers.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchPendingTeachers,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: EmptyStateWidget(
                icon: Icons.check_circle_outline_rounded,
                title: 'All Caught Up!',
                message: 'There are no pending teacher applications awaiting approval.',
                actionText: 'Back to Dashboard',
                onAction: () => context.go('/dashboard'),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPendingTeachers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingTeachers.length,
        itemBuilder: (context, index) {
          final teacher = _pendingTeachers[index];

          return AdminPendingTeacherCard(
            teacherEntity: teacher,
            onApprove: () => _onApprove(teacher.id, teacher.fullName),
            onReject: () => _onReject(teacher.id, teacher.fullName),
          );
        },
      ),
    );
  }
}
