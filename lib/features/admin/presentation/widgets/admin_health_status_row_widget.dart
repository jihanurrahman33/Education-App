import 'package:flutter/material.dart';

class AdminHealthStatusRowWidget extends StatelessWidget {
  final String label;
  final String status;
  final IconData icon;
  final Color statusColor;

  const AdminHealthStatusRowWidget({
    super.key,
    required this.label,
    required this.status,
    required this.icon,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: statusColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          status,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: statusColor,
          ),
        ),
      ],
    );
  }
}
