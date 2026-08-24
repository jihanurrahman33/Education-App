import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TeacherOnboardingStepRowWidget extends StatelessWidget {
  final String step;
  final String title;
  final String subtitle;
  final bool isDone;
  final bool isActive;

  const TeacherOnboardingStepRowWidget({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    this.isDone = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDone
        ? AppColors.secondary
        : isActive
            ? AppColors.warning
            : AppColors.outline;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
          child: Center(
            child: isDone
                ? Icon(Icons.check, size: 16, color: color)
                : Text(
                    step,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDone || isActive ? AppColors.onSurface : AppColors.outline,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
