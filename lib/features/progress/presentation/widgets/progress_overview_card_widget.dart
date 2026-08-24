import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProgressOverviewCardWidget extends StatelessWidget {
  final String completionRate;
  final String completedLessons;
  final String enrolledCourses;
  final String certificatesCount;

  const ProgressOverviewCardWidget({
    super.key,
    required this.completionRate,
    required this.completedLessons,
    required this.enrolledCourses,
    required this.certificatesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Total Completion Rate',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            completionRate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricCol(completedLessons, 'Completed Lessons'),
              Container(height: 24, width: 1, color: Colors.white24),
              _buildMetricCol(enrolledCourses, 'Enrolled Courses'),
              Container(height: 24, width: 1, color: Colors.white24),
              _buildMetricCol(certificatesCount, 'Certificates'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
