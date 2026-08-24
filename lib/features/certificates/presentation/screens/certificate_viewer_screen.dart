import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/certificate_frame_widget.dart';

class CertificateViewerScreen extends StatelessWidget {
  final int certificateId;

  const CertificateViewerScreen({super.key, required this.certificateId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Certificate of Completion',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            tooltip: 'Share Certificate',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Certificate credential URL copied to clipboard!')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Reusable Digital Certificate Frame Widget
              CertificateFrameWidget(
                certificateId: certificateId,
                studentName: 'John Doe',
                courseTitle: 'Full-Stack Modern App Architecture',
                issueDate: 'August 24, 2026',
                credentialCode: 'EDU-CERT-8849-$certificateId',
              ),
              const SizedBox(height: 28),

              // Actions
              CustomButton(
                text: 'Download PDF Certificate',
                icon: Icons.download_rounded,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Downloading official certificate PDF...'),
                      backgroundColor: AppColors.secondary,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Back to Certificates Gallery',
                isOutlined: true,
                textColor: Colors.white,
                onPressed: () => context.go('/certificates'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
