import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SocialLoginButtonsWidget extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;
  final String dividerText;

  const SocialLoginButtonsWidget({
    super.key,
    this.onGoogleTap,
    this.onAppleTap,
    this.dividerText = 'OR CONTINUE WITH',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                dividerText,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.outline,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.g_mobiledata_rounded, size: 24),
                label: const Text('Google'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.onSurface,
                  side: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onGoogleTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.apple_rounded, size: 20),
                label: const Text('Apple'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.onSurface,
                  side: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onAppleTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
