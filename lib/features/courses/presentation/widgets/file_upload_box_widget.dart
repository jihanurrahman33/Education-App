import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class FileUploadBoxWidget extends StatelessWidget {
  final String title;
  final String hintText;
  final String? selectedFileName;
  final IconData icon;
  final VoidCallback onTap;

  const FileUploadBoxWidget({
    super.key,
    required this.title,
    required this.hintText,
    this.selectedFileName,
    this.icon = Icons.upload_file_rounded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selectedFileName != null
                      ? AppColors.roleTeacher.withValues(alpha: 0.6)
                      : AppColors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 36,
                    color: AppColors.roleTeacher,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedFileName ?? hintText,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selectedFileName != null ? FontWeight.bold : FontWeight.normal,
                      color: selectedFileName != null ? AppColors.secondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
