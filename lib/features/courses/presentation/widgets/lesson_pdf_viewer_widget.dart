import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LessonPdfViewerWidget extends StatelessWidget {
  final String fileName;
  final String details;
  final VoidCallback onOpenPdf;

  const LessonPdfViewerWidget({
    super.key,
    this.fileName = 'Chapter_Notes_Reference.pdf',
    this.details = '14 Pages • Downloaded 1.8 MB',
    required this.onOpenPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: double.infinity,
      color: AppColors.surfaceContainerLow,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.picture_as_pdf_rounded, size: 48, color: AppColors.error),
          const SizedBox(height: 10),
          Text(
            fileName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            details,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.download_rounded, size: 16),
            label: const Text('Open PDF Reader'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
            ),
            onPressed: onOpenPdf,
          ),
        ],
      ),
    );
  }
}
