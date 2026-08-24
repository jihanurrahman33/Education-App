import '../../../../core/networking/api_client.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAllAsRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  const NotificationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    return const [
      NotificationModel(
        id: 1,
        title: 'New Lesson Released',
        message: 'Chapter 3 Lesson 4 has been uploaded to "Full-Stack Modern App Architecture".',
        time: '10 mins ago',
        isRead: false,
        type: 'lesson',
      ),
      NotificationModel(
        id: 2,
        title: 'Quiz Evaluation Complete',
        message: 'You scored 90% in "BLoC State Management Fundamentals".',
        time: '2 hours ago',
        isRead: false,
        type: 'quiz',
      ),
      NotificationModel(
        id: 3,
        title: 'Certificate Ready for Download',
        message: 'Congratulations! Your certificate for "UI/UX Design Systems in Flutter" is available.',
        time: '1 day ago',
        isRead: true,
        type: 'certificate',
      ),
    ];
  }

  @override
  Future<void> markAllAsRead() async {
    // Simulates mark all as read API request
  }
}
