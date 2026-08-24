import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class AuthBrandHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final double iconSize;

  const AuthBrandHeaderWidget({
    super.key,
    this.title = AppConstants.appName,
    this.subtitle = 'Sign in to access your learning portal',
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/icon.svg',
              fit: BoxFit.contain,
              placeholderBuilder: (_) => Icon(
                Icons.school_rounded,
                size: iconSize,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
