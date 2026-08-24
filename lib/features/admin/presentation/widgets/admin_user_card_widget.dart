import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/status_badge.dart';

class AdminUserCardWidget extends StatelessWidget {
  final Map<String, dynamic> user;

  const AdminUserCardWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final role = user['role'] as String;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.surfaceContainer,
              child: Text(
                (user['fullName'] as String)[0],
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['fullName'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '@${user['username']} • ${user['email']}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Joined: ${user['joined']}',
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
                  StatusBadge.approval(user['isApproved'] == true),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
