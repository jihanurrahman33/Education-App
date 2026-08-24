import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AdminStatMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String? trend;

  const AdminStatMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            if (trend != null) ...[
              const SizedBox(height: 4),
              Text(trend!, style: const TextStyle(fontSize: 11, color: AppColors.secondary)),
            ],
          ],
        ),
      ),
    );
  }
}
