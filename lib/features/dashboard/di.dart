import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/dashboard_remote_data_source.dart';
import 'data/repositories/dashboard_repository_impl.dart';
import 'domain/repositories/dashboard_repository.dart';
import 'domain/usecases/get_student_dashboard_use_case.dart';
import 'domain/usecases/get_teacher_dashboard_use_case.dart';

void initDashboardFeature(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetStudentDashboardUseCase(sl()));
  sl.registerLazySingleton(() => GetTeacherDashboardUseCase(sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
}
