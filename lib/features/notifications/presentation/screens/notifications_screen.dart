import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, dynamic>> mockNotifications = const [
    {
      'id': 1,
      'title': 'New Lesson Released',
      'message': 'Chapter 3 Lesson 4 has been uploaded to "Full-Stack Modern App Architecture".',
      'time': '10 mins ago',
      'isRead': false,
      'icon': Icons.video_collection_rounded,
      'color': AppColors.primary,
    },
    {
      'id': 2,
      'title': 'Quiz Evaluation Complete',
      'message': 'You scored 90% in "BLoC State Management Fundamentals".',
      'time': '2 hours ago',
      'isRead': false,
      'icon': Icons.emoji_events_rounded,
      'color': AppColors.secondary,
    },
    {
      'id': 3,
      'title': 'Certificate Ready for Download',
      'message': 'Congratulations! Your certificate for "UI/UX Design Systems in Flutter" is available.',
      'time': '1 day ago',
      'isRead': true,
      'icon': Icons.workspace_premium_rounded,
      'color': AppColors.accent,
    },
  ];

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
          'Notifications',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read.')),
              );
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: mockNotifications.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.notifications_off_outlined,
              title: 'No Notifications',
              message: 'You are all caught up! Updates about your courses and quizzes will appear here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockNotifications.length,
              itemBuilder: (context, index) {
                final notif = mockNotifications[index];
                final isRead = notif['isRead'] as bool;
                final color = notif['color'] as Color;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  color: isRead ? Colors.white : AppColors.surfaceContainerLowest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(notif['icon'] as IconData, color: color, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notif['title'] as String,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    notif['time'] as String,
                                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif['message'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
