import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class TeacherPendingScreen extends StatelessWidget {
  const TeacherPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.hourglass_top_rounded,
                      size: 44,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Teacher Verification Pending',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Thank you for registering as an instructor on EduFlow! To uphold educational quality, our administrative team reviews all teacher credentials before authorizing course publishing.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Review steps card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        _buildStepRow(
                          step: '1',
                          title: 'Account Submitted',
                          subtitle: 'Your profile details are recorded.',
                          isDone: true,
                        ),
                        const SizedBox(height: 16),
                        _buildStepRow(
                          step: '2',
                          title: 'Admin Quality Review',
                          subtitle: 'Admin validates instructor credentials.',
                          isDone: false,
                          isActive: true,
                        ),
                        const SizedBox(height: 16),
                        _buildStepRow(
                          step: '3',
                          title: 'Course Creation Unlocked',
                          subtitle: 'You can publish courses and upload lessons.',
                          isDone: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    text: 'Refresh Application Status',
                    icon: Icons.refresh_rounded,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Checking latest instructor authorization status...'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Return to Dashboard',
                    isOutlined: true,
                    onPressed: () => context.go('/dashboard'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow({
    required String step,
    required String title,
    required String subtitle,
    bool isDone = false,
    bool isActive = false,
  }) {
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
