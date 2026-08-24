import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingIndicatorWidget extends StatelessWidget {
  final int totalPages;
  final int currentPageIndex;

  const OnboardingIndicatorWidget({
    super.key,
    required this.totalPages,
    required this.currentPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isSelected = index == currentPageIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isSelected ? 30 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
