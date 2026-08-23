import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/progress_remote_data_source.dart';
import 'data/repositories/progress_repository_impl.dart';
import 'domain/repositories/progress_repository.dart';
import 'domain/usecases/get_progress_summary_usecase.dart';
import 'domain/usecases/mark_lesson_completed_usecase.dart';

void initProgressFeature(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<ProgressRemoteDataSource>(
    () => ProgressRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(remoteDataSource: sl<ProgressRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<GetProgressSummaryUseCase>(
    () => GetProgressSummaryUseCase(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<MarkLessonCompletedUseCase>(
    () => MarkLessonCompletedUseCase(sl<ProgressRepository>()),
  );
}
