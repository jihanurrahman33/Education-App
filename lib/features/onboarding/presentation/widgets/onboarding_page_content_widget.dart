import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/onboarding_item_entity.dart';

class OnboardingPageContentWidget extends StatelessWidget {
  final OnboardingItemEntity item;

  const OnboardingPageContentWidget({
    super.key,
    required this.item,
  });

  IconData _getPrimaryIcon(int id) {
    return switch (id) {
      1 => Icons.auto_stories_rounded,
      2 => Icons.quiz_rounded,
      3 => Icons.workspace_premium_rounded,
      _ => Icons.school_rounded,
    };
  }

  IconData _getSecondaryIcon(int id) {
    return switch (id) {
      1 => Icons.video_collection_rounded,
      2 => Icons.psychology_rounded,
      3 => Icons.military_tech_rounded,
      _ => Icons.stars_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Color(item.accentColorValue);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Visual Container
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.85, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.8),
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.25),
                    blurRadius: 36,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    _getPrimaryIcon(item.id),
                    size: 78,
                    color: accentColor,
                  ),
                  Positioned(
                    bottom: 18,
                    right: 18,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(
                        _getSecondaryIcon(item.id),
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 38),

          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              item.badge,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.25,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),

          // Description
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
