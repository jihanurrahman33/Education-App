import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {
  const LoadNotificationsEvent();
}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final int notificationId;

  const MarkNotificationAsReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class ClearAllNotificationsEvent extends NotificationEvent {
  const ClearAllNotificationsEvent();
}
