import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class NotificationItemCardWidget extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String type;
  final VoidCallback onTap;

  const NotificationItemCardWidget({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
    required this.onTap,
  });

  IconData _getIcon() {
    switch (type) {
      case 'lesson':
        return Icons.play_lesson_rounded;
      case 'quiz':
        return Icons.quiz_rounded;
      case 'certificate':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getColor() {
    switch (type) {
      case 'lesson':
        return AppColors.primary;
      case 'quiz':
        return AppColors.secondary;
      case 'certificate':
        return AppColors.accent;
      default:
        return AppColors.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: isRead ? Colors.white : AppColors.primary.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isRead
              ? AppColors.outlineVariant.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_getIcon(), size: 20, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
