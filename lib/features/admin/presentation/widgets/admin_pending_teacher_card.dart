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
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.roleTeacher.withValues(alpha: 0.15),
                  child: Text(
                    fullName.isNotEmpty ? fullName[0].toUpperCase() : 'T',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.roleTeacher,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '@$username • $email',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'PENDING',
                    style: TextStyle(
                      fontSize: 9,
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
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.phone_outlined, size: 15, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Phone: $phone • Applied: $dateJoined',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: onReject,
                    child: const Text('Reject', style: TextStyle(fontSize: 12)),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_rounded, size: 15),
                    label: const Text('Approve Teacher', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: onApprove,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
