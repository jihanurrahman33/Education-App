import '../../../../core/utils/typedefs.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  const GetNotificationsUseCase(this.repository);

  ResultFuture<List<NotificationEntity>> call() {
    return repository.getNotifications();
  }
}
