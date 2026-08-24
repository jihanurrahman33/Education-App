import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppToast {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.secondary,
      icon: Icons.check_circle_rounded,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_outline_rounded,
      textColor: AppColors.onPrimary,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Color textColor = Colors.white,
    Duration duration = const Duration(milliseconds: 2200),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
