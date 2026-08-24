import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/admin_user_entity.dart';

class AdminUserCardWidget extends StatelessWidget {
  final Map<String, dynamic>? user;
  final AdminUserEntity? userEntity;

  const AdminUserCardWidget({super.key, this.user, this.userEntity});

  @override
  Widget build(BuildContext context) {
    final fullName = userEntity?.fullName ?? user?['fullName'] as String? ?? 'User';
    final username = userEntity?.username ?? user?['username'] as String? ?? '';
    final email = userEntity?.email ?? user?['email'] as String? ?? '';
    final role = userEntity?.role ?? user?['role'] as String? ?? 'student';
    final isApproved = userEntity?.isApprovedTeacher ?? user?['isApproved'] as bool? ?? false;
    final dateJoined = userEntity?.dateJoined != null && userEntity!.dateJoined!.length >= 10
        ? userEntity!.dateJoined!.substring(0, 10)
        : (user?['joined'] as String? ?? 'Recent');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.surfaceContainer,
              child: Text(
                fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '@$username • $email',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Joined: $dateJoined',
                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge.role(role),
                if (role == 'teacher') ...[
                  const SizedBox(height: 4),
                  StatusBadge.approval(isApproved),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
