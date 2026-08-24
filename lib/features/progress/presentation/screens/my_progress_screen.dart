import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/course_progress_breakdown_card.dart';
import '../widgets/progress_overview_card_widget.dart';

class MyProgressScreen extends StatelessWidget {
  const MyProgressScreen({super.key});

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
          'My Learning Progress',
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
            // Reusable Overall Stats Card
            const ProgressOverviewCardWidget(
              completionRate: '68%',
              completedLessons: '18',
              enrolledCourses: '4',
              certificatesCount: '2',
            ),
            const SizedBox(height: 24),

            const Text(
              'Course Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // Reusable Course Breakdown Cards
            CourseProgressBreakdownCard(
              title: 'Full-Stack Modern App Architecture',
              completedLessons: 15,
              totalLessons: 20,
              progress: 0.75,
              isEligibleForCertificate: false,
              onAction: () => context.push('/learning/1/lesson/1'),
            ),
            const SizedBox(height: 12),

            CourseProgressBreakdownCard(
              title: 'UI/UX Design Systems in Flutter',
              completedLessons: 12,
              totalLessons: 12,
              progress: 1.0,
              isEligibleForCertificate: true,
              onAction: () => context.push('/certificates/1'),
            ),
          ],
        ),
      ),
    );
  }
}
