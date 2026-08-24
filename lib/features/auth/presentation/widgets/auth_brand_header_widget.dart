import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AuthBrandHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final double iconSize;

  const AuthBrandHeaderWidget({
    super.key,
    this.title = 'EduFlow',
    this.subtitle = 'Welcome back to your learning journey',
    this.iconSize = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: iconSize + 28,
            height: iconSize + 28,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.school_rounded,
              size: iconSize,
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
