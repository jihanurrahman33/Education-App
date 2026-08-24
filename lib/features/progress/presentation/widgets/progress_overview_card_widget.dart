import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProgressOverviewCardWidget extends StatelessWidget {
  final String completionRate;
  final String completedCourses;
  final String completedLessons;
  final String enrolledCourses;
  final String certificatesCount;

  const ProgressOverviewCardWidget({
    super.key,
    required this.completionRate,
    this.completedCourses = '0',
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
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Total Completion Rate',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
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
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricCol(completedCourses, 'Completed\nCourses'),
              Container(height: 28, width: 1, color: Colors.white24),
              _buildMetricCol(completedLessons, 'Completed\nLessons'),
              Container(height: 28, width: 1, color: Colors.white24),
              _buildMetricCol(enrolledCourses, 'Enrolled\nCourses'),
              Container(height: 28, width: 1, color: Colors.white24),
              _buildMetricCol(certificatesCount, 'Certificates\nEarned'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
