import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/bottom_nav_bar_widget.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import 'admin_dashboard_screen.dart';
import 'student_dashboard_screen.dart';
import 'teacher_dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

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
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: SvgPicture.asset(
                    'assets/icon.svg',
                    placeholderBuilder: (_) => const Icon(
                      Icons.school_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                _buildRoleBadge(user.role),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Notifications',
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                onPressed: () => context.push('/notifications'),
              ),
              IconButton(
                tooltip: 'Settings',
                icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
                onPressed: () => context.push('/settings'),
              ),
              InkWell(
                onTap: () => context.push('/profile'),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user.fullName.isNotEmpty
                          ? user.fullName[0].toUpperCase()
                          : user.username[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: _buildCurrentTab(user),
          bottomNavigationBar: EduFlowBottomNavBar(
            currentIndex: _currentNavIndex,
            onTap: (index) {
              if (index == 1) {
                context.push('/courses');
              } else if (index == 2) {
                if (user.role == UserRole.student) {
                  context.push('/progress');
                } else if (user.role == UserRole.teacher) {
                  context.push('/teacher/quizzes');
                } else {
                  context.push('/admin/analytics');
                }
              } else if (index == 3) {
                context.push('/profile');
              } else {
                setState(() => _currentNavIndex = index);
              }
            },
            items: [
              const BottomNavItem(
                icon: Icons.dashboard_outlined,
                selectedIcon: Icons.dashboard_rounded,
                label: 'Home',
              ),
              const BottomNavItem(
                icon: Icons.explore_outlined,
                selectedIcon: Icons.explore_rounded,
                label: 'Courses',
              ),
              BottomNavItem(
                icon: user.role == UserRole.student
                    ? Icons.insights_outlined
                    : user.role == UserRole.teacher
                        ? Icons.quiz_outlined
                        : Icons.admin_panel_settings_outlined,
                selectedIcon: user.role == UserRole.student
                    ? Icons.insights_rounded
                    : user.role == UserRole.teacher
                        ? Icons.quiz_rounded
                        : Icons.admin_panel_settings_rounded,
                label: user.role == UserRole.student
                    ? 'Progress'
                    : user.role == UserRole.teacher
                        ? 'Quizzes'
                        : 'Analytics',
              ),
              const BottomNavItem(
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentTab(UserEntity user) {
    return switch (user.role) {
      UserRole.admin => AdminDashboardScreen(user: user),
      UserRole.teacher => TeacherDashboardScreen(user: user),
      UserRole.student => StudentDashboardScreen(user: user),
    };
  }

  Widget _buildRoleBadge(UserRole role) {
    final (badgeColor, label) = switch (role) {
      UserRole.admin => (AppColors.roleAdmin, 'ADMIN'),
      UserRole.teacher => (AppColors.roleTeacher, 'TEACHER'),
      UserRole.student => (AppColors.roleStudent, 'STUDENT'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
