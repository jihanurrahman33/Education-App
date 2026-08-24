import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import 'custom_button.dart';

enum ErrorScreenType {
  notFound, // 404
  forbidden, // 403
  unauthorized, // 401
  serverError, // 500
  networkOffline,
}

class ErrorScreen extends StatelessWidget {
  final ErrorScreenType type;
  final int? statusCode;
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  const ErrorScreen({
    super.key,
    this.type = ErrorScreenType.notFound,
    this.statusCode,
    this.title,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final (defaultCode, defaultTitle, defaultMessage, icon, iconColor) = switch (type) {
      ErrorScreenType.notFound => (
          '404',
          'Page Not Found',
          'The resource or screen you are looking for does not exist or has been moved.',
          Icons.search_off_rounded,
          AppColors.primary
        ),
      ErrorScreenType.forbidden => (
          '403',
          'Access Forbidden',
          'You do not have permission to view this resource. Teacher approval or admin privileges may be required.',
          Icons.gpp_bad_rounded,
          AppColors.warning
        ),
      ErrorScreenType.unauthorized => (
          '401',
          'Authentication Required',
          'Your session has expired or you need to sign in to access this feature.',
          Icons.lock_person_rounded,
          AppColors.roleAdmin
        ),
      ErrorScreenType.serverError => (
          '500',
          'Internal Server Error',
          'An unexpected error occurred on our backend server. Please try again in a few moments.',
          Icons.cloud_off_rounded,
          AppColors.error
        ),
      ErrorScreenType.networkOffline => (
          'Offline',
          'No Internet Connection',
          'Please check your network settings and try reconnecting to the server.',
          Icons.wifi_off_rounded,
          AppColors.textMuted
        ),
    };

    final displayCode = statusCode != null ? '$statusCode' : defaultCode;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 48, color: iconColor),
                ),
                const SizedBox(height: 24),
                Text(
                  displayCode,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: iconColor,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title ?? defaultTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message ?? defaultMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                if (onRetry != null) ...[
                  CustomButton(
                    text: 'Try Again',
                    icon: Icons.refresh_rounded,
                    onPressed: onRetry!,
                    width: 200,
                  ),
                  const SizedBox(height: 12),
                ],
                CustomButton(
                  text: 'Back to Dashboard',
                  isOutlined: true,
                  icon: Icons.home_rounded,
                  onPressed: () => context.go('/dashboard'),
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
