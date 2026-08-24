import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_use_case.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationBloc({
    required this.getNotificationsUseCase,
  }) : super(const NotificationState()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
    on<ClearAllNotificationsEvent>(_onClearAllNotifications);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStatus.loading));

    final result = await getNotificationsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationStatus.failure,
        errorMessage: failure.message,
      )),
      (notifications) => emit(state.copyWith(
        status: NotificationStatus.success,
        notifications: notifications,
      )),
    );
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final updated = state.notifications.map((n) {
      if (n.id == event.notificationId) {
        return NotificationEntity(
          id: n.id,
          title: n.title,
          message: n.message,
          time: n.time,
          isRead: true,
          type: n.type,
        );
      }
      return n;
    }).toList();

    emit(state.copyWith(notifications: updated));
  }

  Future<void> _onClearAllNotifications(
    ClearAllNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(notifications: []));
  }
}
