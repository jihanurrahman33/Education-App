import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/admin_remote_data_source.dart';
import 'data/repositories/admin_repository_impl.dart';
import 'domain/repositories/admin_repository.dart';
import 'domain/usecases/get_admin_stats_use_case.dart';

void initAdminFeature(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetAdminStatsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
}
