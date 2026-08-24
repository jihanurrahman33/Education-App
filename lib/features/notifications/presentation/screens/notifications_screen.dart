import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/notification_item_card_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const LoadNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationBloc>().add(const ClearAllNotificationsEvent());
            },
            child: const Text('Clear all', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          final isLoading =
              state.status == NotificationStatus.loading && state.notifications.isEmpty;

          if (isLoading) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  itemBuilder: (context, index) =>
                      const LoadingSkeletonCard(height: 80, borderRadius: 14),
                ),
              ),
            );
          }

          if (state.notifications.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.notifications_off_rounded,
              title: 'No Notifications',
              message:
                  'You are all caught up! Updates about course announcements and quizzes will appear here.',
              actionText: 'Back to Dashboard',
              onAction: () => context.go('/dashboard'),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 24.0 : 16.0,
                      vertical: 16.0,
                    ),
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      final item = state.notifications[index];

                      return NotificationItemCardWidget(
                        title: item.title,
                        message: item.message,
                        time: item.time,
                        isRead: item.isRead,
                        type: item.type,
                        onTap: () {
                          context
                              .read<NotificationBloc>()
                              .add(MarkNotificationAsReadEvent(item.id));
                          if (item.type == 'quiz') {
                            context.push('/quizzes/1/result?score=9&total=10&percentage=90');
                          } else if (item.type == 'certificate') {
                            context.push('/certificates/1');
                          } else {
                            context.push('/learning/1/lesson/4');
                          }
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
