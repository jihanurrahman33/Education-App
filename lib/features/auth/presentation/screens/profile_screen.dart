import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../admin/presentation/bloc/admin_bloc.dart';
import '../../../certificates/presentation/bloc/certificate_bloc.dart';
import '../../../courses/presentation/bloc/course_bloc.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../../quizzes/presentation/bloc/quiz_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/profile_action_nav_tile.dart';
import '../widgets/profile_header_card_widget.dart';
import '../widgets/profile_info_tile_widget.dart';
import '../widgets/profile_stat_item_widget.dart';

class ProfileScreen extends StatelessWidget {
  final bool isTab;

  const ProfileScreen({super.key, this.isTab = false});

  Future<void> _handleSignOut(BuildContext context) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Sign Out?',
      message: 'Are you sure you want to end your current session on EduFlow?',
      confirmText: 'Sign Out',
      confirmColor: AppColors.error,
      icon: Icons.logout_rounded,
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;

        if (user == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          );
        }

        final certState = context.watch<CertificateBloc>().state;
        final progressState = context.watch<ProgressBloc>().state;
        final quizState = context.watch<QuizBloc>().state;
        final courseState = context.watch<CourseBloc>().state;
        final adminState = context.watch<AdminBloc>().state;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            automaticallyImplyLeading: !isTab,
            leading: isTab
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.textPrimary),
                    onPressed: () => context.pop(),
                  ),
            title: const Text(
              'My Profile',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                tooltip: 'Edit Profile',
                onPressed: () => context.push('/profile/edit'),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined,
                    color: AppColors.textSecondary),
                tooltip: 'Settings',
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 32.0 : 20.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile Avatar & Header Card with Ambient Glow
                        ProfileHeaderCardWidget(
                          user: user,
                          onEditProfile: () => context.push('/profile/edit'),
                        ),
                        const SizedBox(height: 20),

                        // Role-Tailored Activity Counters
                        if (user.role == UserRole.student)
                          Row(
                            children: [
                              Expanded(
                                child: ProfileStatItemWidget(
                                  label: 'Enrolled',
                                  value:
                                      '${progressState.myProgress.length}',
                                  icon: Icons.school_rounded,
                                  color: AppColors.primary,
                                  onTap: () => context.push('/progress'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ProfileStatItemWidget(
                                  label: 'Certificates',
                                  value: '${certState.certificates.length}',
                                  icon: Icons.workspace_premium_rounded,
                                  color: AppColors.secondary,
                                  onTap: () => context.push('/certificates'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ProfileStatItemWidget(
                                  label: 'Quizzes',
                                  value: '${quizState.myResults.length}',
                                  icon: Icons.quiz_rounded,
                                  color: AppColors.tertiary,
                                  onTap: () =>
                                      context.push('/quizzes/results'),
                                ),
                              ),
                            ],
                          )
                        else if (user.role == UserRole.teacher)
                          Row(
                            children: [
                              Expanded(
                                child: ProfileStatItemWidget(
                                  label: 'Authored Courses',
                                  value: '${courseState.teacherCourses.length}',
                                  icon: Icons.menu_book_rounded,
                                  color: AppColors.roleTeacher,
                                  onTap: () =>
                                      context.push('/teacher/courses'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ProfileStatItemWidget(
                                  label: 'Review Quizzes',
                                  value: '${quizState.quizzes.length}',
                                  icon: Icons.fact_check_rounded,
                                  color: AppColors.primary,
                                  onTap: () =>
                                      context.push('/teacher/quizzes'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ProfileStatItemWidget(
                                  label: 'Approval Status',
                                  value: user.isApprovedTeacher
                                      ? 'Active'
                                      : 'Pending',
                                  icon: user.isApprovedTeacher
                                      ? Icons.check_circle_rounded
                                      : Icons.hourglass_top_rounded,
                                  color: user.isApprovedTeacher
                                      ? AppColors.secondary
                                      : AppColors.warning,
                                  onTap: user.isApprovedTeacher
                                      ? null
                                      : () => context.push('/teacher/pending'),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: ProfileStatItemWidget(
                                  label: 'Directory',
                                  value: '${adminState.users.length}',
                                  icon: Icons.group_rounded,
                                  color: AppColors.primary,
                                  onTap: () => context.push('/admin/users'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ProfileStatItemWidget(
                                  label: 'Teacher Queue',
                                  value:
                                      '${adminState.pendingTeachers.length}',
                                  icon: Icons.how_to_reg_rounded,
                                  color: AppColors.roleTeacher,
                                  onTap: () =>
                                      context.push('/admin/teachers/pending'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ProfileStatItemWidget(
                                  label: 'Course Queue',
                                  value: '${adminState.pendingCourses.length}',
                                  icon: Icons.rule_folder_rounded,
                                  color: AppColors.roleAdmin,
                                  onTap: () =>
                                      context.push('/admin/courses/pending'),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),

                        // Learning & Platform Quick Hub
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
                                child: Text(
                                  'Learning & Platform Hub',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (user.role == UserRole.student) ...[
                                ProfileActionNavTile(
                                  title: 'My Course Progress',
                                  subtitle:
                                      'Track completed lessons and active syllabus',
                                  icon: Icons.trending_up_rounded,
                                  iconColor: AppColors.primary,
                                  onTap: () => context.push('/progress'),
                                ),
                                const Divider(
                                    height: 1, color: AppColors.divider),
                                ProfileActionNavTile(
                                  title: 'Official Certificates',
                                  subtitle:
                                      'View and download verified credentials',
                                  icon: Icons.workspace_premium_rounded,
                                  iconColor: AppColors.secondary,
                                  badgeText:
                                      '${certState.certificates.length} Earned',
                                  onTap: () => context.push('/certificates'),
                                ),
                                const Divider(
                                    height: 1, color: AppColors.divider),
                                ProfileActionNavTile(
                                  title: 'Assessment & Quiz History',
                                  subtitle:
                                      'Review test scores, answers, and evaluations',
                                  icon: Icons.history_edu_rounded,
                                  iconColor: AppColors.tertiary,
                                  onTap: () =>
                                      context.push('/quizzes/results'),
                                ),
                                const Divider(
                                    height: 1, color: AppColors.divider),
                              ],
                              if (user.role == UserRole.teacher) ...[
                                ProfileActionNavTile(
                                  title: 'Course Curriculum Manager',
                                  subtitle:
                                      'Build chapters, lessons, and video content',
                                  icon: Icons.video_library_rounded,
                                  iconColor: AppColors.roleTeacher,
                                  onTap: () =>
                                      context.push('/teacher/courses'),
                                ),
                                const Divider(
                                    height: 1, color: AppColors.divider),
                                ProfileActionNavTile(
                                  title: 'Quiz & Evaluation Manager',
                                  subtitle:
                                      'Create questions and review submissions',
                                  icon: Icons.assignment_turned_in_rounded,
                                  iconColor: AppColors.primary,
                                  onTap: () =>
                                      context.push('/teacher/quizzes'),
                                ),
                                const Divider(
                                    height: 1, color: AppColors.divider),
                              ],
                              if (user.role == UserRole.admin) ...[
                                ProfileActionNavTile(
                                  title: 'Platform Analytics',
                                  subtitle:
                                      'Overview of enrollments and moderation',
                                  icon: Icons.insights_rounded,
                                  iconColor: AppColors.primary,
                                  onTap: () => context.push('/admin/analytics'),
                                ),
                                const Divider(
                                    height: 1, color: AppColors.divider),
                                ProfileActionNavTile(
                                  title: 'User Management Directory',
                                  subtitle:
                                      'Manage student, teacher, and admin accounts',
                                  icon: Icons.manage_accounts_rounded,
                                  iconColor: AppColors.roleTeacher,
                                  onTap: () => context.push('/admin/users'),
                                ),
                                const Divider(
                                    height: 1, color: AppColors.divider),
                              ],
                              ProfileActionNavTile(
                                title: 'Notification Center',
                                subtitle:
                                    'Course updates, certificates, and alerts',
                                icon: Icons.notifications_outlined,
                                iconColor: AppColors.info,
                                onTap: () => context.push('/notifications'),
                              ),
                              const Divider(
                                  height: 1, color: AppColors.divider),
                              ProfileActionNavTile(
                                title: 'Settings & Preferences',
                                subtitle:
                                    'Dark mode, download options, and security',
                                icon: Icons.tune_rounded,
                                iconColor: AppColors.textSecondary,
                                onTap: () => context.push('/settings'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Account Metadata Information
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Account Credentials & Security',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ProfileInfoTileWidget(
                                label: 'User ID',
                                value: '#${user.id}',
                                icon: Icons.tag_rounded,
                              ),
                              const Divider(
                                  height: 24, color: AppColors.divider),
                              ProfileInfoTileWidget(
                                label: 'Username',
                                value: user.username,
                                icon: Icons.alternate_email_rounded,
                              ),
                              const Divider(
                                  height: 24, color: AppColors.divider),
                              ProfileInfoTileWidget(
                                label: 'Email Address',
                                value: user.email,
                                icon: Icons.mail_outline_rounded,
                              ),
                              const Divider(
                                  height: 24, color: AppColors.divider),
                              ProfileInfoTileWidget(
                                label: 'Role Authority',
                                value: user.role.toApiValue().toUpperCase(),
                                icon: Icons.verified_user_outlined,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Sign Out Action Button
                        CustomButton(
                          text: 'Sign Out',
                          isOutlined: true,
                          icon: Icons.logout_rounded,
                          textColor: AppColors.error,
                          backgroundColor: AppColors.error,
                          onPressed: () => _handleSignOut(context),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
