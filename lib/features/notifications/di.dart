import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/notification_remote_data_source.dart';
import 'data/repositories/notification_repository_impl.dart';
import 'domain/repositories/notification_repository.dart';
import 'domain/usecases/get_notifications_use_case.dart';

void initNotificationFeature(GetIt sl) {
  // Use case
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
}
