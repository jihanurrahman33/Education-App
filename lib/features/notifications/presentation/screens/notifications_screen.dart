import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../widgets/notification_item_card_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'New Lesson Released',
      'message': 'Chapter 3 Lesson 4 has been uploaded to "Full-Stack Modern App Architecture".',
      'time': '10 mins ago',
      'isRead': false,
      'type': 'lesson',
    },
    {
      'id': 2,
      'title': 'Quiz Evaluation Complete',
      'message': 'You scored 90% in "BLoC State Management Fundamentals".',
      'time': '2 hours ago',
      'isRead': false,
      'type': 'quiz',
    },
    {
      'id': 3,
      'title': 'Certificate Ready for Download',
      'message': 'Congratulations! Your certificate for "UI/UX Design Systems in Flutter" is available.',
      'time': '1 day ago',
      'isRead': true,
      'type': 'certificate',
    },
  ];

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read.')),
    );
  }

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
            onPressed: _markAllRead,
            child: const Text('Mark all read', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? EmptyStateWidget(
              icon: Icons.notifications_off_rounded,
              title: 'No Notifications',
              message: 'You are all caught up! Updates about course announcements and quizzes will appear here.',
              actionText: 'Back to Dashboard',
              onAction: () => context.go('/dashboard'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final item = _notifications[index];

                return NotificationItemCardWidget(
                  title: item['title'] as String,
                  message: item['message'] as String,
                  time: item['time'] as String,
                  isRead: item['isRead'] as bool,
                  type: item['type'] as String,
                  onTap: () {
                    setState(() {
                      item['isRead'] = true;
                    });
                    if (item['type'] == 'quiz') {
                      context.push('/quizzes/1/result?score=9&total=10&percentage=90');
                    } else if (item['type'] == 'certificate') {
                      context.push('/certificates/1');
                    } else {
                      context.push('/learning/1/lesson/4');
                    }
                  },
                );
              },
            ),
    );
  }
}
