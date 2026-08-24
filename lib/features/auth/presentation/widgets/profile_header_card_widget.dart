import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/user_entity.dart';

class ProfileHeaderCardWidget extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onEditProfile;

  const ProfileHeaderCardWidget({
    super.key,
    required this.user,
    required this.onEditProfile,
  });

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppColors.roleAdmin;
      case UserRole.teacher:
        return AppColors.roleTeacher;
      case UserRole.student:
        return AppColors.roleStudent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(user.role);
    final initial = user.fullName.isNotEmpty
        ? user.fullName[0].toUpperCase()
        : (user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: roleColor.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background ambient light gradient
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: roleColor.withValues(alpha: 0.12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Avatar with layered gradient ring
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            roleColor,
                            roleColor.withValues(alpha: 0.4),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: roleColor.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.surfaceDark,
                        child: Text(
                          initial,
                          style: TextStyle(
                            color: roleColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 20,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Name & Username
                Text(
                  user.fullName.isNotEmpty ? user.fullName : user.username,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),

                // Username & Email Copy Chip
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: user.email));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email copied to clipboard!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '@${user.username} • ${user.email}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.copy_rounded,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatusBadge.role(user.role.toApiValue()),
                    if (user.role == UserRole.teacher) ...[
                      const SizedBox(width: 8),
                      StatusBadge.approval(user.isApprovedTeacher),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Edit Profile Button
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit Profile Information'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: onEditProfile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
