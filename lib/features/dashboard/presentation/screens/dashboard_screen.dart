import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/bottom_nav_bar_widget.dart';
import '../../../admin/presentation/screens/admin_analytics_screen.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/screens/profile_screen.dart';
import '../../../courses/presentation/screens/course_list_screen.dart';
import '../../../progress/presentation/screens/my_progress_screen.dart';
import '../../../quizzes/presentation/screens/teacher_quiz_manager_screen.dart';
import 'admin_dashboard_screen.dart';
import 'student_dashboard_screen.dart';
import 'teacher_dashboard_screen.dart';
import 'teacher_pending_screen.dart';

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
          appBar: _currentNavIndex == 0 ? _buildHomeAppBar(user) : null,
          body: IndexedStack(
            index: _currentNavIndex,
            children: [
              _buildHomeTab(user),
              const CourseListScreen(isTab: true),
              _buildSecondaryTab(user),
              const ProfileScreen(isTab: true),
            ],
          ),
          bottomNavigationBar: EduFlowBottomNavBar(
            currentIndex: _currentNavIndex,
            onTap: (index) {
              setState(() => _currentNavIndex = index);
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
                        : Icons.analytics_outlined,
                selectedIcon: user.role == UserRole.student
                    ? Icons.insights_rounded
                    : user.role == UserRole.teacher
                        ? Icons.quiz_rounded
                        : Icons.analytics_rounded,
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

  PreferredSizeWidget _buildHomeAppBar(UserEntity user) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/icon.png',
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.school_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
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
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHomeTab(UserEntity user) {
    return switch (user.role) {
      UserRole.admin => AdminDashboardScreen(user: user),
      UserRole.teacher => user.isApprovedTeacher
          ? TeacherDashboardScreen(user: user)
          : const TeacherPendingScreen(isTab: true),
      UserRole.student => StudentDashboardScreen(user: user),
    };
  }

  Widget _buildSecondaryTab(UserEntity user) {
    return switch (user.role) {
      UserRole.student => const MyProgressScreen(isTab: true),
      UserRole.teacher => user.isApprovedTeacher
          ? const TeacherQuizManagerScreen(isTab: true)
          : const TeacherPendingScreen(isTab: true),
      UserRole.admin => const AdminAnalyticsScreen(isTab: true),
    };
  }
}
