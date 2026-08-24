import '../../../../core/utils/typedefs.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  ResultFuture<List<NotificationEntity>> getNotifications();
  ResultVoid markAllAsRead();
}
