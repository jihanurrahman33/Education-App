import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/admin_user_entity.dart';

class AdminPendingTeacherCard extends StatelessWidget {
  final Map<String, dynamic>? teacher;
  final AdminUserEntity? teacherEntity;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const AdminPendingTeacherCard({
    super.key,
    this.teacher,
    this.teacherEntity,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final fullName = teacherEntity?.fullName ?? teacher?['fullName'] as String? ?? 'Teacher Applicant';
    final username = teacherEntity?.username ?? teacher?['username'] as String? ?? '';
    final email = teacherEntity?.email ?? teacher?['email'] as String? ?? '';
    final phone = teacherEntity?.phone ?? teacher?['phone'] as String? ?? 'No phone provided';
    final dateJoined = teacherEntity?.dateJoined != null && teacherEntity!.dateJoined!.length >= 10
        ? teacherEntity!.dateJoined!.substring(0, 10)
        : (teacher?['appliedDate'] as String? ?? 'Recent');

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.roleTeacher.withValues(alpha: 0.12),
                  child: Text(
                    fullName.isNotEmpty ? fullName[0].toUpperCase() : 'T',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.roleTeacher,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        '@$username • $email',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'PENDING',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.phone_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Phone: $phone • Applied: $dateJoined',
                      style: const TextStyle(fontSize: 12, color: AppColors.onSurface),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: onReject,
                  child: const Text('Reject'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('Approve Teacher'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: onApprove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
