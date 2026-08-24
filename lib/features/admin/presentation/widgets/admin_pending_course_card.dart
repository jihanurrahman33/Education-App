import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/admin_course_entity.dart';

class AdminPendingCourseCard extends StatelessWidget {
  final Map<String, dynamic>? course;
  final AdminCourseEntity? courseEntity;
  final VoidCallback onReview;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const AdminPendingCourseCard({
    super.key,
    this.course,
    this.courseEntity,
    required this.onReview,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final title = courseEntity?.title ?? course?['title'] as String? ?? 'Untitled Course';
    final instructor = courseEntity?.teacherName ?? course?['instructor'] as String? ?? 'Instructor';
    final category = course?['category'] as String? ?? 'GENERAL';
    final date = courseEntity?.createdAt != null && courseEntity!.createdAt.length >= 10
        ? courseEntity!.createdAt.substring(0, 10)
        : (course?['submittedDate'] as String? ?? 'Recent');
    final chapters = course?['chaptersCount']?.toString() ?? 'Pending';
    final lessons = course?['lessonsCount']?.toString() ?? 'Review';

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Text(
                  'Submitted $date',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Instructor: $instructor • $chapters • $lessons',
              style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.preview_rounded, size: 16),
                  label: const Text('Review Curriculum'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                  onPressed: onReview,
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: onReject,
                  child: const Text('Reject'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('Approve'),
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
