import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/admin_review_chapter_widget.dart';

class AdminCourseReviewScreen extends StatelessWidget {
  final int courseId;

  const AdminCourseReviewScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Course Quality Review',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PENDING QUALITY AUDIT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const Text(
                        'Author: Dr. Robert Smith',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Advanced Microservices with Dart & Docker',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Covers containerization, gRPC service communication, distributed tracing, and horizontal scaling in cloud clusters.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Submitted Chapters & Content Verification',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // Reusable Admin Review Chapter Widgets
            const AdminReviewChapterWidget(
              chapterNum: '1',
              title: 'Container Fundamentals & Dockerfile Optimization',
              lessons: [
                'Lesson 1.1: Docker Engine Architecture (14 mins HD Video)',
                'Lesson 1.2: Multi-stage Build Strategies (PDF Guide)',
              ],
            ),
            const SizedBox(height: 10),

            const AdminReviewChapterWidget(
              chapterNum: '2',
              title: 'Inter-service gRPC & Protocol Buffers',
              lessons: [
                'Lesson 2.1: Proto Definitions & Code Generation (20 mins HD Video)',
                'Lesson 2.2: Stream Interceptors & Authentication (18 mins HD Video)',
              ],
            ),
            const SizedBox(height: 28),

            // Decision Actions
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Reject with Feedback',
                    icon: Icons.cancel_outlined,
                    backgroundColor: AppColors.error,
                    onPressed: () async {
                      final confirmed = await ConfirmationDialog.show(
                        context,
                        title: 'Reject Course Draft?',
                        message: 'Send rejection notice to instructor for content updates.',
                        confirmText: 'Reject Draft',
                        confirmColor: AppColors.error,
                      );
                      if (confirmed == true && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Course draft returned for revision.')),
                        );
                        context.pop();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Approve & Publish',
                    icon: Icons.check_circle_rounded,
                    backgroundColor: AppColors.secondary,
                    onPressed: () async {
                      final confirmed = await ConfirmationDialog.show(
                        context,
                        title: 'Approve Course Publication?',
                        message: 'This course will go live in the public catalog for all students.',
                        confirmText: 'Approve',
                        confirmColor: AppColors.secondary,
                      );
                      if (confirmed == true && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Course approved and published live!'),
                            backgroundColor: AppColors.secondary,
                          ),
                        );
                        context.pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
