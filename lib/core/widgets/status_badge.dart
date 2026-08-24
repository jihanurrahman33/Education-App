import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum StatusBadgeType {
  approved,
  pending,
  rejected,
  draft,
  published,
  completed,
  inProgress,
  roleStudent,
  roleTeacher,
  roleAdmin,
}

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
    this.icon,
  });

  factory StatusBadge.role(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return const StatusBadge(
          label: 'ADMIN',
          type: StatusBadgeType.roleAdmin,
          icon: Icons.shield_rounded,
        );
      case 'teacher':
        return const StatusBadge(
          label: 'TEACHER',
          type: StatusBadgeType.roleTeacher,
          icon: Icons.school_rounded,
        );
      case 'student':
      default:
        return const StatusBadge(
          label: 'STUDENT',
          type: StatusBadgeType.roleStudent,
          icon: Icons.person_rounded,
        );
    }
  }

  factory StatusBadge.approval(bool isApproved) {
    if (isApproved) {
      return const StatusBadge(
        label: 'Approved',
        type: StatusBadgeType.approved,
        icon: Icons.check_circle_rounded,
      );
    }
    return const StatusBadge(
      label: 'Pending Approval',
      type: StatusBadgeType.pending,
      icon: Icons.schedule_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor, defaultIcon) = switch (type) {
      StatusBadgeType.approved ||
      StatusBadgeType.published ||
      StatusBadgeType.completed => (
          AppColors.secondary.withValues(alpha: 0.12),
          AppColors.secondary,
          Icons.check_circle_rounded
        ),
      StatusBadgeType.pending || StatusBadgeType.inProgress => (
          AppColors.accent.withValues(alpha: 0.15),
          AppColors.tertiaryContainer,
          Icons.pending_actions_rounded
        ),
      StatusBadgeType.rejected => (
          AppColors.error.withValues(alpha: 0.12),
          AppColors.error,
          Icons.cancel_rounded
        ),
      StatusBadgeType.draft => (
          AppColors.outlineVariant.withValues(alpha: 0.3),
          AppColors.textSecondary,
          Icons.edit_note_rounded
        ),
      StatusBadgeType.roleStudent => (
          AppColors.primary.withValues(alpha: 0.12),
          AppColors.primary,
          Icons.person_rounded
        ),
      StatusBadgeType.roleTeacher => (
          AppColors.roleTeacher.withValues(alpha: 0.12),
          AppColors.roleTeacher,
          Icons.school_rounded
        ),
      StatusBadgeType.roleAdmin => (
          AppColors.roleAdmin.withValues(alpha: 0.12),
          AppColors.roleAdmin,
          Icons.admin_panel_settings_rounded
        ),
    };

    final effectiveIcon = icon ?? defaultIcon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(effectiveIcon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
