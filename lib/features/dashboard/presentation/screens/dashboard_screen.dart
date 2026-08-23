import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import 'admin_dashboard_screen.dart';
import 'student_dashboard_screen.dart';
import 'teacher_dashboard_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status.isUnauthenticated) {
          context.go('/login');
        }
      },
      builder: (context, state) {
        final user = state.user;

        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Icon(Icons.school_rounded, color: AppColors.primary, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Education App',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(width: 8),
                _buildRoleBadge(user.role),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                },
              ),
            ],
          ),
          body: _buildRoleDashboard(user),
        );
      },
    );
  }

  Widget _buildRoleBadge(UserRole role) {
    Color badgeColor;
    String label;

    switch (role) {
      case UserRole.admin:
        badgeColor = AppColors.roleAdmin;
        label = 'ADMIN';
        break;
      case UserRole.teacher:
        badgeColor = AppColors.roleTeacher;
        label = 'TEACHER';
        break;
      case UserRole.student:
      default:
        badgeColor = AppColors.roleStudent;
        label = 'STUDENT';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRoleDashboard(UserEntity user) {
    switch (user.role) {
      case UserRole.admin:
        return AdminDashboardScreen(user: user);
      case UserRole.teacher:
        return TeacherDashboardScreen(user: user);
      case UserRole.student:
      default:
        return StudentDashboardScreen(user: user);
    }
  }
}
